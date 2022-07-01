class Api::SolaCms::FranchisingInquiriesController < Api::SolaCms::ApiController
  before_action :set_franchising_inquiry, only: %i[ show update destroy]

  #GET /home_buttons
  def index
    if params[:search].present?
      franchising_inquiries = FranchisingForm.search_by_email(params[:search])
      franchising_inquiries = paginate(franchising_inquiries)
      render json:  { franchising_inquiries: franchising_inquiries }.merge(meta: pagination_details(franchising_inquiries))
    else  
      franchising_inquiries = FranchisingForm.all
      franchising_inquiries = paginate(franchising_inquiries)
      render json: { franchising_inquiries: franchising_inquiries }.merge(meta: pagination_details(franchising_inquiries))
    end
  end

  #POST /home_buttons
  def create
    @franchising_inquiry  =  FranchisingForm.new(franchising_inquiry_params)
    if @franchising_inquiry.save
      render json: @franchising_inquiry
    else
      Rails.logger.info(@franchising_inquiry.errors.messages)
      render json: {error: @franchising_inquiry.errors.messages}, status: 400
    end 
  end 

  #GET /home_buttons/:id
  def show
    render json: @franchising_inquiry
  end 

  #PUT /home_buttons/:id
  def update
    if @franchising_inquiry.update(franchising_inquiry_params)
      render json: {message: "Home Button Successfully Updated."}, status: 200
    else
      Rails.logger.info(@franchising_inquiry.errors.messages)
      render json: {error: @franchising_inquiry.errors.messages}, status: 400
    end  
  end 

  #DELETE /home_buttons/:id
  def destroy
    if @home_button&.destroy
      render json: {message: "Home Button Successfully Deleted."}, status: 200
    else
      @franchising_inquiry.errors.messages
      Rails.logger.info(@franchising_inquiry.errors.messages)
    end
  end 

  private

  def set_franchising_inquiry
    @franchising_inquiry = FranchisingForm.find(params[:id])
  end

  def franchising_inquiry_params
    params.require(:franchising_form).permit(:first_name, :last_name, :email_address, :phone_number, :multi_unit_operator, :liquid_capital, :city, :state, :agree_to_receive_email, :utm_source, :utm_campaign, :utm_medium, :utm_content, :utm_term, :country)
  end
end
