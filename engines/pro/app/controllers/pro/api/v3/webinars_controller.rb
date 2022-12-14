# frozen_string_literal: true

module Pro
  class Api::V3::WebinarsController < Api::V3::ApiController
    load_and_authorize_resource class: 'Video', instance_name: :webinar, only: %i[index show]

    def index
      @webinars = @webinars.webinars.includes(:countries).where(countries: { code: current_user.location_country })
      @webinars = @webinars.search(params[:q]) if params[:q].present?
      @webinars = @webinars.where(is_featured: params[:featured] == 'true') if params[:featured].present?
      @webinars = @webinars.where(brand_id: params[:brand_id]) if params[:brand_id].present?
      @webinars = @webinars.where(id: Video.includes(:categories).where(categories: { id: params[:category_id] }).select(:id)) if params[:category_id].present?
      if params[:suggested].present?
        videos_by_categories = Video.includes(:categories).where(categories: { id: current_user.categories.pluck(:id) }).ids
        @webinars = @webinars.where('videos.id in (?) or videos.brand_id in (?)', videos_by_categories, current_user.brands.pluck(:id))
      end
      @webinars = history_scope(@webinars)
      respond_with(paginate(@webinars), root: 'webinars', include: '**')
    end

    def show
      respond_with(@webinar)
    end
  end
end
