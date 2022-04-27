# frozen_string_literal: true

module Pro
  class Api::V3::DealsController < Api::V3::ApiController
    load_and_authorize_resource only: %i[index show]

    def index
      @deals = @deals.includes(:countries).where(countries: { code: current_user.location_country })
      @deals = @deals.search(params[:q]) if params[:q].present?
      @deals = @deals.where(is_featured: params[:featured] == 'true') if params[:featured].present?
      @deals = @deals.where(brand_id: params[:brand_id]) if params[:brand_id].present?
      @deals = @deals.where(id: Deal.includes(:categories).where(categories: { id: params[:category_id] }).select(:id)) if params[:category_id].present?
      @deals = history_scope(@deals)
      respond_with(paginate(@deals), include: '**')
    end

    def show
      respond_with(@deal)
    end
  end
end
