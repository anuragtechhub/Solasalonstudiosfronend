# frozen_string_literal: true
class Api::SolaCms::DealsController < Api::SolaCms::ApiController
  before_action :get_deal, only: %i[ show update destroy]

  def index
    @deals = params[:search].present? ? search_deal : Deal.order("#{field} #{order}")
    @deals = paginate(@deals)
    render json:  { deals: @deals }.merge(meta: pagination_details(@deals))
  end

  def create
    @deal = Deal.new(deal_params)
    if @deal.save
      render json: @deal, status: 200
    else
      Rails.logger.error(@deal.errors.messages)
      render json: {error: @deal.errors.messages}, status: 400 
    end
  end

  def show
    render json: @deal
  end

  def update
    if @deal.update(deal_params)
      render json: {message: "Deal Successfully Updated."}, status: 200
    else
      Rails.logger.error(@deal.errors.messages)
      render json: {errors: format_activerecord_errors(@deal.errors) }, status: 400
    end 
  end

  def destroy
    if @deal&.destroy
      render json: { message: "deleted successfully."}
    else
      Rails.logger.error(@deal.errors.messages)
      render json: {errors: format_activerecord_errors(@deal.errors) }, status: 400
    end  
  end

  private

  def get_deal
    @deal = Deal.find_by(id: params[:id])
    return render(json: { error: "Record not found!"}, status: 404) unless @deal.present?
  end

  def deal_params
    params.require(:deal).permit(:title, :description, :brand_id, :image, :file, :more_info_url, :is_featured, :delete_image, :delete_file, country_ids: [], category_ids: [], tag_ids: [])
  end

  def search_deal
    Deal.order("#{field} #{order}").search(params[:search])
  end 
end
