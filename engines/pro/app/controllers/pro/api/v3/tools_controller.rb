module Pro
  class Api::V3::ToolsController < Api::V3::ApiController
    load_and_authorize_resource only: %i[index show]

    def index
      @tools = @tools.includes(:countries).where(countries: {code: current_user.location_country }).with_file
      @tools = @tools.search(params[:q]) if params[:q].present?
      @tools = @tools.where(is_featured: params[:featured] == 'true') if params[:featured].present?
      @tools = @tools.where(brand_id: params[:brand_id]) if params[:brand_id].present?
      @tools = @tools.where(id: Tool.includes(:categories).where(categories: { id: params[:category_id] }).pluck(:id)) if params[:category_id].present?
      @tools = history_scope(@tools)
      respond_with(paginate(@tools))
    end

    def show
      respond_with(@tool)
    end
  end
end
