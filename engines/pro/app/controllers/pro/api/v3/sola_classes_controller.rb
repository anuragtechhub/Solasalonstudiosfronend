module Pro
  class Api::V3::SolaClassesController < Api::V3::ApiController
    load_and_authorize_resource only: %i[index show]

    def index
      @sola_classes = @sola_classes.upcoming
      @sola_classes = @sola_classes.search(params[:q]) if params[:q].present?
      @sola_classes = @sola_classes.where(is_featured: params[:featured] == 'true') if params[:featured].present?
      @sola_classes = @sola_classes.includes(:brands).where(brands: {id: params[:brand_id]}) if params[:brand_id].present?
      @sola_classes = @sola_classes.where(category_id: params[:category_id]) if params[:category_id].present?
      @sola_classes = history_scope(@sola_classes)
      respond_with(paginate(@sola_classes.order(start_date: :asc)), include: '**')
    end

    def show
      respond_with(@sola_class)
    end
  end
end
