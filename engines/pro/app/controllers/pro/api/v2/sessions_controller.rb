module Pro
  class Api::V2::SessionsController < ApiController

    def sign_in
      user = get_user(params[:sign_in_email])

      if user&.valid_password?(params[:sign_in_password])
        render json: user
      else
        render json: { errors: [t(:invalid_email_or_password)] }
      end
    end

    def sign_up
      if params[:email].blank? || params[:password].blank? || params[:password_confirmation].blank?
        render :json => {:errors => [t(:please_fill_out_all_fields)]}
      else
        @user = get_user(params[:email], user_only: true)
        if @user&.encrypted_password.present?
          render :json => {:errors => [t(:email_address_already_exists)]}
        elsif @user == nil
          render :json => {:errors => [t(:could_not_find_sola_professional)]}
        else
          if params[:password] != params[:password_confirmation]
            raise StandardError, t(:passwords_do_not_match)
          end
          @user.password = params[:password]
          @user.password_confirmation = params[:password_confirmation]
          if @user.save
            render :json => @user
          else
            render :json => {:errors => @user.errors.to_a}
          end
        end
      end
    rescue => e
      NewRelic::Agent.notice_error(e)
      Rollbar.error(e)
      render :json => {:errors => [e.message]}
    end

    def forgot_password
      if request.post?
        raise StandardError, t(:please_enter_your_email_address) if params[:email].blank?
        @user = get_user(params[:email])

        if @user
          @reset_password = ResetPassword.create userable: @user
          Pro::AppMailer.forgot_password(@reset_password).deliver
          render json: { success: [t(:reset_password_sent_to, { email: @reset_password.email })] }
        else
          raise StandardError, t(:could_not_find_sola_professional)
        end
      end
    rescue => e
      NewRelic::Agent.notice_error(e)
      Rollbar.error(e)
      render :json => {:errors => [e.message]}
    end

    def change_password
      raise StandardError, t(:current_password_is_blank) if params[:current_password].blank?
      user = get_user(params[:email])

      if user&.valid_password?(params[:current_password])
        user.password = params[:password]
        user.password_confirmation = params[:password_confirmation]
        user.save
        render json: user
      else
        render json: { errors: [t(:invalid_email_or_password)] }
      end
    rescue => e
      NewRelic::Agent.notice_error(e)
      Rollbar.error(e)
      render :json => {:errors => [e.message]}
    end

    def reset_password
      @reset_password = ResetPassword.find_by(:public_id => params[:id])
      raise StandardError, t(:invalid_reset_password_token) unless @reset_password
      raise StandardError, t(:reset_password_token_used) unless @reset_password.date_used.nil?

      if request.post?
        raise StandardError, t(:passwords_do_not_match) unless params[:password] == params[:password_confirmation]

        # set new password
        @reset_password.userable.password = params[:password]
        @reset_password.userable.password_confirmation = params[:password_confirmation]
        @reset_password.userable.save

        # update reset password timestamp
        @reset_password.date_used = DateTime.now
        @reset_password.save

        render :json => @reset_password.userable
      end
    rescue => e
      NewRelic::Agent.notice_error(e)
      Rollbar.error(e)
      render :json => {:errors => [e.message]}
    end

    def user
      user = get_user(params[:email])

      if user
        render json: user
      else
        render json: { errors: [t(:you_must_sign_in)] }
      end
    end

    def content
      render json: init_content
    end

    private

    def init_content
      return {
        :videos => init_videos,
        :tools => init_tools,
        :deals => init_deals,
        :brands => init_brands,
        #:blogs => init_blogs,
        :classes => init_classes
      }
    end

    def init_videos
      @videos = Video.where('is_featured != ?', true).order(:created_at => :desc)
      @featured_videos = Video.where(:is_featured => true).order(:created_at => :desc)

      if @videos && @videos.size > 0
        @total_pages = @videos.size / 12 + (@videos.size % 12 == 0 ? 0 : 1)
      else
        @total_pages = 0
      end

      @limit = 12
      @page = params[:page].present? ? params[:page].to_i : 0
      @videos = @videos.limit(@limit).offset(@page * @limit)

      return {
        :total_pages => @total_pages,
        :videos => @videos,
        :featured_videos => @featured_videos,
        :brands => Brand.where(:id => Video.pluck(:brand_id).uniq).order('LOWER(name)'),
        :categories => VideoCategory.where(:id => Video.pluck(:video_category_id).uniq).order('LOWER(name)')
      }
    end

    def init_tools
      @tools = Tool.where('is_featured != ?', true).order(:created_at => :desc)
      @featured_tools = Tool.where(:is_featured => true).order(:created_at => :desc)

      if @tools && @tools.size > 0
        @total_pages = @tools.size / 12 + (@tools.size % 12 == 0 ? 0 : 1)
      else
        @total_pages = 0
      end

      @limit = 12
      @page = params[:page].present? ? params[:page].to_i : 0
      @tools = @tools.limit(@limit).offset(@page * @limit)

      return {
        :total_pages => @total_pages,
        :tools => @tools,
        :featured_tools => @featured_tools,
        :brands => Brand.where(:id => Tool.pluck(:brand_id).uniq).order('LOWER(name)'),
        :categories => ToolCategory.where(:id => Tool.pluck(:tool_category_id).uniq).order('LOWER(name)')
      }
    end

    def init_deals
      @deals = Deal.where('is_featured != ?', true).order(:created_at => :desc)
      @featured_deals = Deal.where(:is_featured => true).order(:created_at => :desc)

      if @deals && @deals.size > 0
        @total_pages = @deals.size / 12 + (@deals.size % 12 == 0 ? 0 : 1)
      else
        @total_pages = 0
      end

      @limit = 12
      @page = params[:page].present? ? params[:page].to_i : 0
      @deals = @deals.limit(@limit).offset(@page * @limit)

      return {
        :total_pages => @total_pages,
        :deals => @deals,
        :featured_deals => @featured_deals,
        :brands => Brand.where(:id => Deal.pluck(:brand_id).uniq).order('LOWER(name)'),
        :categories => DealCategory.where(:id => Deal.pluck(:deal_category_id).uniq).order('LOWER(name)').order(:position => :asc)
      }
    end

    def init_blogs
      @blogs = Blog.where('status = ?', 'published').order(:publish_date => :desc)

      if @blogs && @blogs.size > 0
        @total_pages = @blogs.size / 12 + (@blogs.size % 12 == 0 ? 0 : 1)
      else
        @total_pages = 0
      end

      @limit = 12
      @page = params[:page].present? ? params[:page].to_i : 0
      @blogs = @blogs.limit(@limit).offset(@page * @limit)

      return {
        :total_pages => @total_pages,
        :blogs => @blogs,
        :categories => BlogCategory.order(:name => :asc)
      }
    end

    def init_brands
      @brands = Brand.all.order('LOWER(name)')

      return @brands
    end

    def init_classes
      @classes = SolaClass.order('LOWER(title)').where('end_date >= ?', Date.today)

      return @classes
    end
  end
end
