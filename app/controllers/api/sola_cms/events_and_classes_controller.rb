class Api::SolaCms::EventsAndClassesController < Api::SolaCms::ApiController
  before_action :set_class, only: %i[ show update destroy]

  #GET /events_and_classes
  def index
    @events_and_classes = SolaClass.all
    render json: @events_and_classes
  end

  #POST /events_and_classes
  def create
    @event_and_class =  SolaClass.new(sola_class_params)
    if @event_and_class.save
      render json: @event_and_class
    else
      render json: {error: "Unable to Create Event and Class"}, status: 400
    end 
  end 

  #GET /events_and_classes/:id
  def show
    render json: @event_and_class
  end 

  #PUT /events_and_classes/:id
  def update
    if @event_and_class.update(sola_class_params)
      render json: {message: "Event and Class Successfully Updated."}, status: 200
    else
      render json: {error: "Event and Class to Update Msa."}, status: 400
    end  
  end 

  #DELETE /events_and_classes/:id
  def destroy
    if @event_and_class.destroy
      render json: {message: "Event and Class Successfully Deleted."}, status: 200
    else
      render json: {error: "Unable to Delete Event and Class."}, status: 400
    end
  end 

  private
  def set_class
    @event_and_class = SolaClass.find(params[:id])
  end

  def sola_class_params
    params.require(:sola_class).permit(:title, :description, :category_id, :class_image_id, :cost, :link_text, :admin_id, :link_url, :file_text, :video_id, :start_date, :start_time, :end_date, :end_time, :sola_class_region_id, :location, :address, :city, :state, :brand_ids, :rsvp_email_address, :rsvp_phone_number,  tag_ids: [])
  end
end
