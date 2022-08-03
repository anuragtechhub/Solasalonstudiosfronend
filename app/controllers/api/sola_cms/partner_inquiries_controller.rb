class Api::SolaCms::PartnerInquiriesController < Api::SolaCms::ApiController
  before_action :set_partner_inquiry, only: %i[ show update destroy]

  #GET /partner_inquiries
  def index
    @partner_inquiries =  params[:search].present? ? search_partner_inquiry : PartnerInquiry.order("#{field} #{order}")
    @partner_inquiries = paginate(@partner_inquiries)
    render json:  { partner_inquiries: @partner_inquiries }.merge(meta: pagination_details(@partner_inquiries))
  end
  
  #POST /partner_inquiries
  def create
    @partner_inquiry  =  PartnerInquiry.new(parner_inquiry_params)
    if @partner_inquiry.save
      render json: @partner_inquiry, status: 200
    else
      Rails.logger.info(@partner_inquiry.errors.messages)
      render json: {error: @partner_inquiry.errors.messages}, status: 400
    end
  end

  #GET /partner_inquiries/:id
  def show
    render json: @partner_inquiry
  end
  
  #PUT /partner_inquiries/:id
  def update
    if @partner_inquiry.update(parner_inquiry_params)
      render json: {message: "Partner Inquiry Successfully Updated."}, status: 200
    else
      Rails.logger.info(@partner_inquiry.errors.messages)
      render json: {error: @partner_inquiry.errors.messages}, status: 400
    end
  end

  #DELETE /partner_inquiries/:id
  def destroy
    if @partner_inquiry&.destroy
      render json: {message: "Partner Inqury Successfully Deleted."}, status: 200
    else
      Rails.logger.info(@partner_inquiry.errors.messages)
      render json: {message: format_activerecord_errors(@partner_inquiry.errors) }, status: 400
    end
  end
  private

  def set_partner_inquiry
    @partner_inquiry = PartnerInquiry.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @partner_inquiry.present?
  end 

  def parner_inquiry_params
    params.require(:partner_inquiry).permit(:subject, :name, :company_name, :email, :phone, :message, :request_url, :visit_id)
  end

  def search_partner_inquiry
    PartnerInquiry.order("#{field} #{order}").search_inquiries(params[:search])
  end 
end
