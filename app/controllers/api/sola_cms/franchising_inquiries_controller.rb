class Api::SolaCms::FranchisingInquiriesController < Api::SolaCms::ApiController
  before_action :set_franchising_inquiry, only: %i[ show update destroy]

  #GET /franchise_inquiries
  def index
    @franchising_inquiries = params[:search].present? ? search_franchise_inquiries : FranchisingForm.order("#{field} #{order}")
    @franchising_inquiries = paginate(@franchising_inquiries)
    render json:  { franchising_inquiries: @franchising_inquiries }.merge(meta: pagination_details(@franchising_inquiries))
  end

  #POST /franchise_inquiries
  def create
    @franchising_inquiry  =  FranchisingForm.new(franchising_inquiry_params)
    if @franchising_inquiry.save
      render json: @franchising_inquiry, status: 200
    else
      Rails.logger.error(@franchising_inquiry.errors.messages)
      render json: {error: @franchising_inquiry.errors.messages}, status: 400
    end 
  end 

  #GET /franchise_inquiries/:id
  def show
    render json: @franchising_inquiry, status: 200
  end 

  #PUT /franchise_inquiries/:id
  def update
    if @franchising_inquiry.update(franchising_inquiry_params)
      render json: {message: "Franchise inquiry Successfully Updated."}, status: 200
    else
      Rails.logger.error(@franchising_inquiry.errors.messages)
      render json: {error: @franchising_inquiry.errors.messages}, status: 400
    end  
  end 

  #DELETE /franchise_inquiries/:id
  def destroy
    if @franchising_inquiry&.destroy
      render json: {message: "Franchise inquiry Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@franchising_inquiry.errors.messages)
      render json: {errors: format_activerecord_errors(@franchising_inquiry.errors) }, status: 400
    end
  end 

  private

  def set_franchising_inquiry
    @franchising_inquiry = FranchisingForm.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @franchising_inquiry.present?
  end

  def franchising_inquiry_params
    params.require(:franchising_form).permit(:first_name, :last_name, :email_address, :phone_number, :multi_unit_operator, :liquid_capital, :city, :state, :agree_to_receive_email, :utm_source, :utm_campaign, :utm_medium, :utm_content, :utm_term, :country)
  end

  def search_franchise_inquiries
    FranchisingForm.order("#{field} #{order}").search_by_email(params[:search])
  end 
end
