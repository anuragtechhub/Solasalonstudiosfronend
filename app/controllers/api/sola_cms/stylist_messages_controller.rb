class Api::SolaCms::StylistMessagesController < Api::SolaCms::ApiController
  before_action :set_stylist_message, only: %i[ show update destroy]

  #GET /stylist_messages
  def index
    @stylist_messages = params[:search].present? ? search_stylist_message : StylistMessage.order("#{field} #{order}")
    @stylist_messages = paginate(@stylist_messages)
    render json:  { stylist_messages: @stylist_messages }.merge(meta: pagination_details(@stylist_messages))
  end
  
  #POST /stylist_messages
  def create
    @stylist_message  =  StylistMessage.new(stylist_message_params)
    if @stylist_message.save
      render json: @stylist_message, status: 200
    else
      Rails.logger.error(@stylist_message.errors.messages)
      render json: {error: @stylist_message.errors.messages}, status: 400
    end
  end

  #GET /stylist_messages/:id
  def show
    render json: @stylist_message
  end
  

  #PUT /stylist_messages/:id
  def update
    if @stylist_message.update(stylist_message_params)
      render json: {message: "Stylist Message Successfully Updated."}, status: 200
    else
      Rails.logger.error(@stylist_message.errors.messages)
      render json: {error: @stylist_message.errors.messages}, status: 400
    end
  end

  #DELETE /stylist_messages/:id
  def destroy
    if @stylist_message&.destroy
      render json: {message: "Stylist Message Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@stylist_message.errors.messages)
      render json: {errors: format_activerecord_errors(@stylist_message.errors) }, status: 400
    end
  end

  private

  def set_stylist_message
    @stylist_message = StylistMessage.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @stylist_message.present?
  end 

  def stylist_message_params
    params.require(:stylist_message).permit(:name, :email, :phone, :message, :stylist_id)
  end

  def search_stylist_message
    StylistMessage.order("#{field} #{order}").search_by_stylist_message(params[:search])
  end
end