class Api::SolaCms::StylistMessagesController < Api::SolaCms::ApiController
  before_action :set_stylist_message, only: %i[ show update destroy]

  #GET /stylist_messages
  def index
    @stylist_messages = StylistMessage.page(params[:page] || 1 )
    render json: @stylist_messages
  end
  
  #POST /stylist_messages
  def create
    @stylist_message  =  StylistMessage.new(stylist_message_params)
    if @stylist_message.save
      render json: @stylist_message
    else
      Rails.logger.info(@stylist_message.errors.messages)
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
      Rails.logger.info(@stylist_message.errors.messages)
      render json: {error: @stylist_message.errors.messages}, status: 400
    end
  end

  #DELETE /stylist_messages/:id
  def destroy
    if @stylist_message&.destroy
      render json: {message: "Stylist Message Successfully Deleted."}, status: 200
    else
      @stylist_message.errors.messages
      Rails.logger.info(@stylist_message.errors.messages)
    end
  end

  private

  def set_stylist_message
    @stylist_message = StylistMessage.find(params[:id])
  end 

  def stylist_message_params
    params.require(:stylist_message).permit(:name, :email, :phone, :message, :stylist_id)
  end 
end