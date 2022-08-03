class Api::SolaCms::HomeButtonsController < Api::SolaCms::ApiController
  before_action :home_button, only: %i[ show update destroy]

  #GET /home_buttons
  def index
    @home_buttons = params[:search].present? ? search_home_button : HomeButton.order("#{field} #{order}")
    @home_buttons = paginate(@home_buttons)
    render json:  { home_buttons: @home_buttons }.merge(meta: pagination_details(@home_buttons))
  end

  #POST /home_buttons
  def create
    @home_button  =  HomeButton.new(home_button_params)
    if @home_button.save
      render json: @home_button, status: 200
    else
      Rails.logger.error(@home_button.errors.messages)
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
      Rails.logger.error(@home_button.errors.messages)
      render json: {error: @home_button.errors.messages}, status: 400
    end  
  end 

  #DELETE /home_buttons/:id
  def destroy
    if @home_button&.destroy
      render json: {message: "Home Button Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@home_button.errors.messages)
      render json: {message: format_activerecord_errors(@home_button.errors) }, status: 400
    end
  end 
  private

  def home_button
    @home_button = HomeButton.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @home_button.present?
  end

  def home_button_params
    params.require(:home_button).permit(:image, :action_link, :delete_image, :position, country_ids: [])
  end

  def search_home_button
    HomeButton.order("#{field} #{order}").search_by_id(params[:search])
  end
end
