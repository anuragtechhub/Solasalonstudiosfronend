class Api::SolaCms::ToolsAndResourcesController < Api::SolaCms::ApiController
  before_action :set_tools_and_resource, only: %i[ show update destroy]

  #GET /tools_and_resources
  def index
    if params[:search].present?
      tools_and_resources = Tool.search_by_id_and_brand_name(params[:search])
      tools_and_resources = paginate(tools_and_resources)
      render json:  { tools_and_resources: tools_and_resources }.merge(meta: pagination_details(tools_and_resources))
    else  
      tools_and_resources = Tool.all
      tools_and_resources = paginate(tools_and_resources)
      render json: { tools_and_resources: tools_and_resources }.merge(meta: pagination_details(tools_and_resources))
    end
  end

  #POST /tools_and_resources
  def create 
    @tools_and_resource  =  Tool.new(tool_params)
    if @tools_and_resource.save
      render json: @tools_and_resource 
    else
      Rails.logger.info(@tools_and_resource.errors.messages)
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
      Rails.logger.info(@tools_and_resource.errors.messages)
      render json: {error: @tools_and_resource.errors.messages}, status: 400
    end 
  end 

  #DELETE /tools_and_resources/:id
  def destroy
    if @tools_and_resource&.destroy
      render json: {message: "Tool Successfully Deleted."}, status: 200
    else
      @tools_and_resource.errors.messages
      Rails.logger.info(@tools_and_resource.errors.messages)
    end
  end

  private

  def set_tools_and_resource
    @tools_and_resource = Tool.find(params[:id])
  end

  def tool_params
    params.require(:tool).permit(:brand_id, :title, :description, :is_featured, :image, :file, :link_url,:youtube_url, :views, country_ids: [], category_ids: [], tag_ids: [], video_ids: [])
  end 
end
