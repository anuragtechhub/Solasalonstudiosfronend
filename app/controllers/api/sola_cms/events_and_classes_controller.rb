class Api::SolaCms::EventsAndClassesController < Api::SolaCms::ApiController
  before_action :set_class, only: %i[ show update destroy]

  #GET /events_and_classes
  def index
    @event_and_classes = params[:search].present? ? search_event_and_classes : SolaClass.order("#{field} #{order}")
    @event_and_classes = paginate(@event_and_classes)
    render json:  { event_and_classes: @event_and_classes }.merge(meta: pagination_details(@event_and_classes))
  end

  #POST /events_and_classes
  def create
    @event_and_class =  SolaClass.new(sola_class_params)
    if @event_and_class.save
      render json: @event_and_class, status: 200
    else
      render json: {error: @event_and_class.errors.messages}, status: 400
      Rails.logger.error(@event_and_class.errors.messages)
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
      render json: {error: @event_and_class.errors.messages}, status: 400
      Rails.logger.error(@event_and_class.errors.messages)
    end  
  end 

  #DELETE /events_and_classes/:id
  def destroy
    if @event_and_class&.destroy
      render json: {message: "Event and Class Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@event_and_class.errors.messages)
      render json: {errors: format_activerecord_errors(@event_and_class.errors) }, status: 400
    end
  end 

  private
  def set_class
    @event_and_class = SolaClass.find_by(id: params[:id])
    return render(json: { error: "Record not found!"}, status: 404) unless @event_and_class.present?
  end

  def sola_class_params
    params.require(:sola_class).permit(:title, :file, :description, :category_id, :class_image_id, :cost, :link_text, :admin_id, :link_url, :file_text, :video_id, :start_date, :start_time, :end_date, :end_time, :sola_class_region_id, :location, :address, :city, :state, :rsvp_email_address, :rsvp_phone_number,  tag_ids: [] , brand_ids: [])
  end

  def search_event_and_classes
    SolaClass.order("#{field} #{order}").search(params[:search])
  end 
end
