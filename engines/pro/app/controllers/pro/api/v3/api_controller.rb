module Pro
	class Api::V3::ApiController < ApiController

		before_action :authorize_user_from_token!
		around_action :handle_action
		after_action :cors_expose_headers

		respond_to :json
		serialization_scope :current_ability

		# HTTP 401 Unauthorized
		class Unauthorized < StandardError; end

		# HTTP 409 Conflict error
		class Conflict < StandardError; end

		# HTTP 423 Locked
		class Inactive < StandardError; end

		rescue_from StandardError do |exception|
			log_exception(exception)
			head 500
		end

		rescue_from Unauthorized do |exception|
			log_exception(exception)
			head 401
		end

		rescue_from Conflict do |exception|
			log_exception(exception)
			head 409
		end

		rescue_from CanCan::AccessDenied do |exception|
			log_exception(exception)
			head 403
		end

		rescue_from Inactive do |exception|
			log_exception(exception)
			head 423
		end

		def history_scope(scope)
			if params[:history].present?
				scope.
					includes(:events).
					where(events: {userable_id: current_user.id, userable_type: current_user.class.name}).
					order('events.created_at desc')
			else
				if params[:q].present? && scope.table_name == 'sola_classes'
					scope.reorder("#{scope.table_name}.start_date asc")
				elsif scope.table_name == 'sola_classes'
					scope.order("#{scope.table_name}.start_date asc")
				elsif params[:q].present? && params[:order].to_s == 'popular'
					scope.reorder("#{scope.table_name}.#{order_field} #{order_vector}")
				elsif params[:suggested].present?
					scope.order(current_user.brands.exists? ? "CASE
						WHEN #{scope.table_name}.brand_id in (#{current_user.brands.pluck(:id).join(',')}) THEN 1
						ELSE 0 END desc" : '', "#{scope.table_name}.#{order_field} #{order_vector}")
				else
					scope.order("#{scope.table_name}.#{order_field} #{order_vector}")
				end
			end
		end

		private

		def log_exception(exception, detailed = false)
			Rails.logger.error "#{exception.class.name}: #{exception.message}\n#{exception.backtrace.join("\n") if detailed}"
		end

		def default_render
			head 204
		end

		def handle_action
			Thread.current[:current_user] = current_user

			yield
		rescue ActiveRecord::RecordNotFound => e
			render json: {errors: [e.message]}, status: 404
		rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordNotDestroyed => e
			render json: {errors: [e.message]}, status: 409
		rescue ActiveRecord::RecordInvalid, ActiveRecord::NestedAttributes::TooManyRecords, ActionController::ParameterMissing => e
			render json: {errors: [e.message]}, status: 422
		ensure
			@current_ability = nil
			@access_token    = nil
			@pager           = nil

			Thread.current[:current_user] = nil
		end

		# Expects Authorization HTTP header
		#  wich should contain the following Token token="..."
		def authorize_user_from_token
			warden.request.env['devise.skip_trackable'] = true
		end

		# Expects Authorization HTTP header
		#  wich should contain the following Token token="..."
		def authorize_user_from_token!
			warden.request.env['devise.skip_trackable'] = true
			if not access_token
				raise Unauthorized
			end
		end

		def access_token
			@access_token ||= read_access_token
		end

		def current_user
			access_token&.user
		end

		def current_user_country
			@current_user_country ||= current_user.location&.country || 'US'
		end

		def current_ability
			@current_ability ||= Ability.new(current_user)
		end

		def order_field
			case params[:order]
			when 'alphabetical'
				'title'
			when 'popular'
				'views'
			else
				'created_at'
			end
		end

		def order_vector
			case params[:order]
			when 'alphabetical'
				'asc'
			else
				'desc'
			end
		end

		# Extract token from headers
		def read_access_token
			ActionController::HttpAuthentication::Token.authenticate(self) do |token|
				if token.present?
					UserAccessToken.find_by(key: token)&.refresh
				end
			end
		end

		def user_sign_in(user)
			user.with_lock do
				user.update!(
					sign_in_count:      user.sign_in_count + 1,
					current_sign_in_at: Time.now,
					last_sign_in_at:    user.current_sign_in_at,
					current_sign_in_ip: request.remote_ip,
					last_sign_in_ip:    user.current_sign_in_ip
				)

				render_token(user)
			end
		end

		def render_token(user)
			raise Inactive, 'User inactive' unless user.active_for_authentication?

			respond_with(user.access_tokens.create!, location: nil)
		end

		def pager
			pagination =
				(params[:page] || {}).reverse_merge(number: 1, size: 20)

			@pager ||= OpenStruct.new(pagination)
		end

		def paginate(collection)
			paginated = case collection
				# when Sunspot::Search::StandardSearch
				#   collection.build { paginate page: pager.number, per_page: pager.size }.execute.results
			when ActiveRecord::Relation, Mongoid::Criteria
				collection.page(pager.number).per(pager.size)
			else
				collection
			end

			set_header 'X-Pager-Total-Count',  paginated.total_count.to_s
			set_header 'X-Pager-Total-Pages',  paginated.total_pages.to_s
			set_header 'X-Pager-Per-Page',     paginated.limit_value.to_s
			set_header 'X-Pager-Current-Page', paginated.current_page.to_s
			set_header 'X-Pager-Next-Page',    paginated.next_page.to_s
			set_header 'X-Pager-Prev-Page',    paginated.prev_page.to_s

			paginated
		end

		def set_header(name, value)
			@custom_headers ||= []

			unless @custom_headers.include?(name)
				@custom_headers << name
			end

			# response.set_header name, value
			response.headers[name] = value
		end

		def cors_expose_headers
			if @custom_headers.present?
				# response.set_header 'Access-Control-Expose-Headers', @custom_headers.join(', ')
				response.headers['Access-Control-Expose-Headers'] = @custom_headers.join(', ')
			end
		end
	end
end