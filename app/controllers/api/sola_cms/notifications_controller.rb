class Api::SolaCms::NotificationsController < Api::SolaCms::ApiController
  before_action :set_notification, only: %i[ show update destroy]

  #GET /notifications
  def index
    @notifications = params[:search].present? ? search_notification : Notification.order("#{field} #{order}")
    @notifications = paginate(@notifications)
    render json:  { notifications: @notifications }.merge(meta: pagination_details(@notifications))
  end

  #POST /notifications
  def create
    @notification  =  Notification.new(notification_params)
    if @notification.save
      render json: @notification, status: 200
    else
      Rails.logger.error(@notification.errors.messages)
      render json: {error: @notification.errors.messages}, status: 400
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
      Rails.logger.error(@notification.errors.messages)
      render json: {message: @notification.errors.messages}, status: 400
    end  
  end 

  #DELETE /notifications/:id
  def destroy
    if @notification&.destroy
      render json: {message: "Notification Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@notification.errors.messages)
      render json: {message: format_activerecord_errors(@notification.errors) }, status: 400
    end
  end 

  private

  def set_notification
    @notification = Notification.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @notification.present?

  end

  def notification_params
    params.require(:notification).permit(:brand_id, :tool_id, :deal_id, :sola_class_id, :video_id, :notification_text, :send_push_notification, :blog_id, :date_sent, :title, :send_at, :country_id, stylist_ids: [])
  end

  def search_notification
    Notification.order("#{field} #{order}").search_notification(params[:search])
  end 
end
