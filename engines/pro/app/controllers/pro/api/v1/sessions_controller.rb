# frozen_string_literal: true

module Pro
  class Api::V1::SessionsController < ApiController
    def sign_in
      if params[:sign_in_email] && params[:sign_in_password]
        user = get_user(params[:sign_in_email])

        if user&.valid_password?(params[:sign_in_password])
          render json: user
        else
          render json: { errors: ['Invalid email and password combination'] }
        end
      else
        render json: { errors: ['Invalid email and password combination'] }
      end
    end

    def sign_up
      if params[:email].blank? || params[:password].blank? || params[:password_confirmation].blank?
        render json: { errors: ['Please fill out all fields'] }
      else
        @user = get_user(params[:email], user_only: true)

        if @user&.encrypted_password.present?
          render json: { errors: ['A user with that email address already exists'.html_safe] }
        elsif @user.nil?
          render json: { errors: ['We could not find a salon professional with that email address in the Sola directory'.html_safe] }
        else
          if params[:password] != params[:password_confirmation]
            raise StandardError, 'Passwords do not match'
          end

          @user.password = params[:password]
          @user.password_confirmation = params[:password_confirmation]
          if @user.save
            render json: @user
          else
            render json: { errors: @user.errors.to_a }
          end
        end
      end
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
      Rollbar.error(e)
      render json: { errors: [e.message] }
    end

    def forgot_password
      if request.post?
        raise StandardError, 'Please enter your email address' if params[:email].blank?

        @user = get_user(params[:email], user_only: true)

        if @user
          @reset_password = ResetPassword.create userable: @user
          Pro::AppMailer.forgot_password(@reset_password).deliver
          render json: { success: ["Reset password email sent to #{@reset_password.email}"] }
        else
          raise StandardError, 'We could not find a user with that email address'
        end
      end
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
      Rollbar.error(e)
      render json: { errors: [e.message] }
    end

    def reset_password
      @reset_password = ResetPassword.find_by(public_id: params[:id])
      raise StandardError, 'Invalid reset password token. Please submit a new forgot password request'.html_safe unless @reset_password
      raise StandardError, 'It appears that this reset password token has already been used. Please submit a new forgot password request'.html_safe unless @reset_password.date_used.nil?

      if request.post?
        raise StandardError, 'Passwords do not match' unless params[:password] == params[:password_confirmation]

        # set new password
        @reset_password.userable.password = params[:password]
        @reset_password.userable.password_confirmation = params[:password_confirmation]
        @reset_password.userable.save

        # update reset password timestamp
        @reset_password.date_used = DateTime.now
        @reset_password.save

        render json: @reset_password.userable
      end
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
      Rollbar.error(e)
      render json: { errors: [e.message] }
    end

    def user
      render json: get_user(params[:email]) || { errors: ['You must sign in'] }
    end

    def content
      render json: init_content
    end

    private

      def init_content
        {
          videos:  init_videos,
          tools:   init_tools,
          deals:   init_deals,
          brands:  init_brands,
          # :blogs => init_blogs,
          classes: init_classes
        }
      end

      def init_videos
        @videos = Video.where.not(is_featured: true).order(created_at: :desc)
        @featured_videos = Video.where(is_featured: true).order(created_at: :desc)

        @total_pages = if @videos&.size&.positive?
                         (@videos.size / 12) + ((@videos.size % 12).zero? ? 0 : 1)
                       else
                         0
                       end

        @limit = 12
        @page = params[:page].present? ? params[:page].to_i : 0
        @videos = @videos.limit(@limit).offset(@page * @limit)

        {
          total_pages:     @total_pages,
          videos:          @videos,
          featured_videos: @featured_videos,
          brands:          Brand.where(id: Video.distinct.select(:brand_id)).order('LOWER(name)'),
          categories:      VideoCategory.where(id: Video.distinct.select(:video_category_id)).order('LOWER(name)')
        }
      end

      def init_tools
        @tools = Tool.where.not(is_featured: true).order(created_at: :desc)
        @featured_tools = Tool.where(is_featured: true).order(created_at: :desc)

        @total_pages = if @tools&.size&.positive?
                         (@tools.size / 12) + ((@tools.size % 12).zero? ? 0 : 1)
                       else
                         0
                       end

        @limit = 12
        @page = params[:page].present? ? params[:page].to_i : 0
        @tools = @tools.limit(@limit).offset(@page * @limit)

        {
          total_pages:    @total_pages,
          tools:          @tools,
          featured_tools: @featured_tools,
          brands:         Brand.where(id: Tool.distinct.select(:brand_id)).order('LOWER(name)'),
          categories:     ToolCategory.where(id: Tool.distinct.select(:tool_category_id)).order('LOWER(name)')
        }
      end

      def init_deals
        @deals = Deal.where.not(is_featured: true).order(created_at: :desc)
        @featured_deals = Deal.where(is_featured: true).order(created_at: :desc)

        @total_pages = if @deals&.size&.positive?
                         (@deals.size / 12) + ((@deals.size % 12).zero? ? 0 : 1)
                       else
                         0
                       end

        @limit = 12
        @page = params[:page].present? ? params[:page].to_i : 0
        @deals = @deals.limit(@limit).offset(@page * @limit)

        {
          total_pages:    @total_pages,
          deals:          @deals,
          featured_deals: @featured_deals,
          brands:         Brand.where(id: Deal.distinct.select(:brand_id)).order('LOWER(name)'),
          categories:     DealCategory.where(id: Deal.distinct.select(:deal_category_id)).order('LOWER(name)').order(position: :asc)
        }
      end

      def init_blogs
        @blogs = Blog.where(status: 'published').order(publish_date: :desc)

        @total_pages = if @blogs&.size&.positive?
                         (@blogs.size / 12) + ((@blogs.size % 12).zero? ? 0 : 1)
                       else
                         0
                       end

        @limit = 12
        @page = params[:page].present? ? params[:page].to_i : 0
        @blogs = @blogs.limit(@limit).offset(@page * @limit)

        {
          total_pages: @total_pages,
          blogs:       @blogs,
          categories:  BlogCategory.order(name: :asc)
        }
      end

      def init_brands
        @brands = Brand.all.order('LOWER(name)')

        @brands
      end

      def init_classes
        @classes = SolaClass.order('LOWER(title)').where('end_date >= ?', Date.today)

        @classes
      end
  end
end
