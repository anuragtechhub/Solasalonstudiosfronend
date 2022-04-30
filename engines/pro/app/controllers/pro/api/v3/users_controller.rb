# frozen_string_literal: true

module Pro
  class Api::V3::UsersController < Api::V3::ApiController
    skip_before_action :authorize_user_from_token!, only: %i[has_password]

    def current
      serializer = current_user.is_a?(Admin) ? Api::V3::AdminSerializer : Api::V3::UserSerializer
      respond_with(current_user, serializer: serializer, root: 'user')
    end

    def shopify_url
      token = Shopify::MultipassToken.new(current_user).generate_token
      render json: { url: "https://www.beautyhive.com/account/login/multipass/#{token}" }
    end

    def update
      if params[:user][:password].present? && !current_user.valid_password?(params[:user][:current_password])
        render json: { errors: [t(:invalid_current_password)] }
      else
        current_user.update!(update_params)
        render json: { success: true, user: current_user }
      end
    end

    def has_password
      user = Stylist.find_by(email_address: params[:email]) if params[:email].present?
      raise ActiveRecord::RecordNotFound if user.blank?

      render json: { has_password: user.encrypted_password.present? }
    end

    private

      def update_params
        params.require(:user)
          .permit(:name, :first_name, :last_name, :onboarded,
                  :current_password, :password, :password_confirmation,
                  :delete_image_1, :delete_image_2, :delete_image_3, :delete_image_4, :delete_image_5,
                  :delete_image_6, :delete_image_7, :delete_image_8, :delete_image_9, :delete_image_10,
                  :c_image_1_url, :c_image_2_url, :c_image_3_url, :c_image_4_url, :c_image_5_url,
                  :c_image_6_url, :c_image_7_url, :c_image_8_url, :c_image_9_url, :c_image_10_url,
                  :sola_pro_platform, :sola_pro_version, tags_ids: [], brands_ids: [], categories_ids: []).tap do |permitted|
          permitted[:name] = "#{permitted[:first_name]} #{permitted[:last_name]}" if 'first_name'.in?(params[:user].keys) || 'last_name'.in?(params[:user].keys)
          permitted[:tags] = Tag.where(id: permitted.delete(:tags_ids)) if 'tags_ids'.in?(params[:user].keys)
          permitted[:brands] = Brand.where(id: permitted.delete(:brands_ids)) if 'brands_ids'.in?(params[:user].keys)
          permitted[:categories] = Category.where(id: permitted.delete(:categories_ids)) if 'categories_ids'.in?(params[:user].keys)
          if permitted[:password].present? && !current_user.valid_password?(permitted[:current_password])
            permitted.delete(:password) && permitted.delete(:password_confirmation)
          end
          permitted.delete(:first_name)
          permitted.delete(:last_name)
          permitted.delete(:current_password)
        end
      end
  end
end
