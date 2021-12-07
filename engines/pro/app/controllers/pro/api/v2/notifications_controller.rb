module Pro
  class Api::V2::NotificationsController < ApiController

    def token
      stylist = Stylist.where(:email_address => params[:email], :status => 'open').order(:created_at).first
      admin = Admin.where(:email => params[:email]).order(:created_at).first

      if stylist
        device = Device.find_or_create_by(:userable_id => stylist.id, :userable_type => 'Stylist', :uuid => params[:uuid])
        if params[:token] && params[:token].class.name == 'ActionController::Parameters'
          device.token = params[:token][:token]
        else
          device.token = params[:token]
        end
        device.name = params[:name]
        device.platform = params[:platform] if params[:platform]
        device.save
        render :json => {:success => true}
      elsif admin
        device = Device.find_or_create_by(:userable_id => admin.id, :userable_type => 'Admin', :uuid => params[:uuid])
        if params[:token] && params[:token].class.name == 'ActionController::Parameters'
          device.token = params[:token][:token]
        else
          device.token = params[:token]
        end
        device.name = params[:name]
        device.platform = params[:platform] if params[:platform]
        device.save
        render :json => {:success => true}
      else
        render :json => {:errors => [t(:could_not_find_salon_professional)]}
      end
    end

    def dismiss
      userable = get_user(params[:email])
      if userable
        user_notification = UserNotification.find_by(:userable_id => userable.id, :userable_type => userable.class.name, :notification_id => params[:notification_id])
        if user_notification
          user_notification.dismiss_date = DateTime.now
          user_notification.save
        end
      end
      render :json => {:success => true}
    end

  end
end