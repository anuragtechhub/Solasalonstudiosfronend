class Api::SolaCms::RequestTourInquiriesController < Api::SolaCms::ApiController
  before_action :set_inquiry, only: %i[ show update destroy]

  #GET /request_tour_inquiries
  def index
    @request_tour_inquiries = RequestTourInquiry.all
    render json: @request_tour_inquiries
  end

  #POST /request_tour_inquiries
  def create
    @request_tour_inquiry  =  RequestTourInquiry.new(inquiry_params)
    if @request_tour_inquiry.save
      render json: @request_tour_inquiry
    else
      render json: {error: "Unable to Create Request Tour Inquiry"}, status: 400
    end
  end

  #GET /request_tour_inquiries/:id
  def show
    render json: @request_tour_inquiry
  end
  
  def update
    if @request_tour_inquiry.update(inquiry_params)
      render json: {message: "Request Tour Inquiry Successfully Updated."}, status: 200
    else
      render json: {error: "Unable to Update Request Tour Inquiry."}, status: 400
    end
  end

  def destroy
    if @request_tour_inquiry.destroy
      render json: {message: "Inqury Successfully Deleted."}, status: 200
    else
      render json: {error: "Unable to Delete Inquiry."}, status: 400
    end
  end

  private

  def set_inquiry
    @request_tour_inquiry = RequestTourInquiry.find(params[:id])
  end 

  def inquiry_params
    params.require(:request_tour_inquiry).permit(:name, :email, :phone, :message, :request_url,  :visit_id, :contact_preference, :newsletter, :location_id, :services, :how_can_we_help_you, :i_would_like_to_be_contacted, :dont_see_your_location, :send_email_to_prospect, :content, :source, :medium, :campaign, :zip_code, :hutk, :state, :canada_locations, :utm_source, :utm_medium, :utm_medium, :utm_content, :created_at)
  end 
end
