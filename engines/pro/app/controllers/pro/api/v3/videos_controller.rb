module Pro
  class Api::V3::VideosController < Api::V3::ApiController
    load_and_authorize_resource only: %i[index show]

    def index
      @videos = @videos.not_webinars unless params[:suggested].present?
      @videos = @videos.includes(:countries).where(countries: {code: current_user.location_country })
      @videos = @videos.search(params[:q]) if params[:q].present?
      @videos = @videos.where(is_featured: params[:featured] == 'true') if params[:featured].present?
      @videos = @videos.where(brand_id: params[:brand_id]) if params[:brand_id].present?
      @videos = @videos.where(id: Video.includes(:categories).where(categories: { id: params[:category_id] }).pluck(:id)) if params[:category_id].present?
      if params[:suggested].present?
        videos_by_categories = Video.includes(:categories).where(categories: { id: current_user.categories.pluck(:id) }).pluck(:id)
        @videos = @videos.where('videos.id in (?) or videos.brand_id in (?)', videos_by_categories, current_user.brands.pluck(:id))
      end
      @videos = history_scope(@videos)
      respond_with(paginate(@videos), include: '**')
    end

    def show
      respond_with(@video)
    end
  end
end
