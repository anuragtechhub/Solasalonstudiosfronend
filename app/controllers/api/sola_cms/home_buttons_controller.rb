class Api::SolaCms::HomeButtonsController < Api::SolaCms::ApiController
  before_action :home_button, only: %i[ show update destroy]

  #GET /home_buttons
  def index
    @home_buttons = HomeButton.all
    render json: @home_buttons
  end

  #POST /home_buttons
  def create
    @home_button  =  HomeButton.new(home_button_params)
    if @home_button.save
      render json: @home_button
    else
      Rails.logger.info(@home_button.errors.messages)
      render json: {error: @home_button.errors.messages}, status: 400
    end 
  end 

  #GET /home_buttons/:id
  def show
    render json: @home_button
  end 

  #PUT /home_buttons/:id
  def update
    if @home_button.update(home_button_params)
      render json: {message: "Home Button Successfully Updated."}, status: 200
    else
      Rails.logger.info(@home_button.errors.messages)
      render json: {error: @home_button.errors.messages}, status: 400
    end  
  end 

  #DELETE /home_buttons/:id
  def destroy
    if @home_button&.destroy
      render json: {message: "Home Button Successfully Deleted."}, status: 200
    else
      @home_button.errors.messages
      Rails.logger.info(@home_button.errors.messages)
    end
  end 

  private

  def home_button
    @home_button = HomeButton.find(params[:id])
  end

  def home_button_params
    params.require(:home_button).permit(:image, :action_link, :position, country_ids: [])
  end
end
