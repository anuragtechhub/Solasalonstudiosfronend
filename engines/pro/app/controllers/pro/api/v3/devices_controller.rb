module Pro
  class Api::V3::DevicesController < Api::V3::ApiController
    load_and_authorize_resource through: :current_user,
                                find_by: :token, id_param: :token,
                                only: %i[index show update]
    def index
      respond_with(paginate(@devices))
    end

    def show
      respond_with(@device)
    end

    def create
      @device = current_user.devices.create(create_params)
      respond_with(@device, location: nil)
    end

    def update
      @device.update!(update_params)
    end

    private

    def create_params
      params.require(:device).permit(:uuid, :name, :token, :platform, :app_version, :internal_rating_popup_showed_at,
                                     :native_rating_popup_showed_at, :internal_feedback)
    end

    def update_params
      params.require(:device).permit(:uuid, :name, :platform, :app_version, :internal_rating_popup_showed_at,
                                     :native_rating_popup_showed_at, :internal_feedback)
    end
  end
end
