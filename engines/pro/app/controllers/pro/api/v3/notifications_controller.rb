# frozen_string_literal: true

module Pro
  class Api::V3::NotificationsController < Api::V3::ApiController
    def index
      respond_with(paginate(current_user.notifications.order(created_at: :desc)))
    end

    def create
      device = current_user.devices.find_or_create_by(token: device_params[:token])
      device.update(device_params)
      respond_with(device, location: nil)
    end

    def destroy
      current_user
        .user_notifications
        .find(params[:id])
        .update_attribute(:dismiss_date, DateTime.current)

      render json: { success: true }
    end

    private

      def device_params
        params.require(:device).permit(:uuid, :token, :name, :platform, :app_version)
      end
  end
end
