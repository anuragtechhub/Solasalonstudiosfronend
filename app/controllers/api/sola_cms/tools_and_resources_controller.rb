class Api::SolaCms::ToolsAndResourcesController < Api::SolaCms::ApiController
  before_action :set_tools_and_resource, only: %i[ show update destroy]

  #GET /tools_and_resources
  def index
    @tools_and_resources = params[:search].present? ? search_tool : Tool.order("#{field} #{order}")
    @tools_and_resources = paginate(@tools_and_resources)
    render json:  { tools_and_resources: @tools_and_resources }.merge(meta: pagination_details(@tools_and_resources))
  end

  #POST /tools_and_resources
  def create 
    @tools_and_resource  =  Tool.new(tool_params)
    if @tools_and_resource.save
      render json: @tools_and_resource, status: 200
    else
      Rails.logger.error(@tools_and_resource.errors.messages)
      render json: {error: @tools_and_resource.errors.messages}, status: 400
    end
  end

  #GET /tools_and_resources/:id
  def show
    render json: @tools_and_resource
  end

  #PUT /tools_and_resources/:id
  def update
    if @tools_and_resource.update(tool_params)
      render json: {message: "Tool Successfully Updated."}, status: 200
    else
      Rails.logger.error(@tools_and_resource.errors.messages)
      render json: {error: @tools_and_resource.errors.messages}, status: 400
    end 
  end 

  #DELETE /tools_and_resources/:id
  def destroy
    if @tools_and_resource&.destroy
      render json: {message: "Tool Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@tools_and_resource.errors.messages)
      render json: {errors: format_activerecord_errors(@tools_and_resource.errors) }, status: 400
    end
  end

  private

  def set_tools_and_resource
    @tools_and_resource = Tool.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @tools_and_resource.present?
  end

  def tool_params
    params.require(:tool).permit(:brand_id, :title, :description, :is_featured, :image, :file, :link_url,:youtube_url, :views, :delete_image, :delete_file, country_ids: [], category_ids: [], tag_ids: [])
  end

  def search_tool
    Tool.order("#{field} #{order}").search_by_id_and_brand_name(params[:search])
  end 
end
