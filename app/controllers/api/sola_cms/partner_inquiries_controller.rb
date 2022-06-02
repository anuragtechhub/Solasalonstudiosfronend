class Api::SolaCms::PartnerInquiriesController < Api::SolaCms::ApiController
  before_action :set_partner_inquiry, only: %i[ show update destroy]

  #GET /partner_inquiries
  def index
    @partner_inquiries = PartnerInquiry.all
    render json: @partner_inquiries
  end
  
  #POST /partner_inquiries
  def create
    @partner_inquiry  =  PartnerInquiry.new(parner_inquiry_params)
    if @partner_inquiry.save
      render json: @partner_inquiry
    else
      render json: {error: "Unable to Create Partner Inquiry"}, status: 400
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
      render json: {error: "Unable to Update Partner Inquiry."}, status: 400
    end
  end

  #DELETE /partner_inquiries/:id
  def destroy
    if @partner_inquiry.destroy
      render json: {message: "Partner Inqury Successfully Deleted."}, status: 200
    else
      render json: {error: "Unable to Delete Partner Inquiry."}, status: 400
    end
  end

  private

  def set_partner_inquiry
    @partner_inquiry = PartnerInquiry.find(params[:id])
  end 

  def parner_inquiry_params
    params.require(:partner_inquiry).permit(:subject, :name, :company_name, :email, :phone, :message, :request_url)
  end 
end
