class Api::SolaCms::NotificationsController < Api::SolaCms::ApiController
  before_action :set_notification, only: %i[ show update destroy]

  #GET /notifications
  def index
    @notifications = Notification.all
    render json: @notifications
  end

  #POST /notifications
  def create
    @notification  =  Notification.new(notification_params)
    if @notification.save
      render json: @notification
    else
      render json: {error: "Unable to Create Notification"}, status: 400
    end 
  end 

  #GET /notifications/:id
  def show
    render json: @notification
  end 

  #PUT /notifications/:id
  def update
    if @notification.update(notification_params)
      render json: {message: "Notification Successfully Updated."}, status: 200
    else
      render json: {error: "Unable to Update Notification."}, status: 400
    end  
  end 

  #DELETE /notifications/:id
  def destroy
    if @notification.destroy
      render json: {message: "Notification Successfully Deleted."}, status: 200
    else
      render json: {error: "Unable to Delete Notification."}, status: 400
    end
  end 

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end

  def notification_params
    params.require(:notification).permit(:brand_id, :tool_id, :deal_id, :sola_class_id, :video_id, :notification_text, :send_push_notification, :blog_id, :date_sent, :title, :send_at, :country_id, stylist_ids: [])
  end
end
