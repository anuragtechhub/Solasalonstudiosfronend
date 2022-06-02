class Api::SolaCms::ToolsAndResourcesController < Api::SolaCms::ApiController
  before_action :set_tools_and_resource, only: %i[ show update destroy]

  #GET /tools_and_resources
  def index
    @tools_and_resources = Tool.all
    render json: @tools_and_resources
  end

  #POST /tools_and_resources
  def create 
    @tools_and_resource  =  Tool.new(tool_params)
    if @tools_and_resource.save
      render json: @tools_and_resource 
    else
      render json: {error: "Unable to Create Tool"}, status: 400
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
      render json: {error: "Unable to Update Tool."}, status: 400
    end 
  end 

  #DELETE /tools_and_resources/:id
  def destroy
    if @tools_and_resource.destroy
      render json: {message: "Tool Successfully Deleted."}, status: 200
    else
      render json: {error: "Unable to Delete Tool."}, status: 400
    end
  end

  private

  def set_tools_and_resource
    @tools_and_resource = Tool.find(params[:id])
  end

  def tool_params
    params.require(:tool).permit(:brand_id, :title, :description, :is_featured, :image, :file, :link_url,:youtube_url, :views, country_ids: [])
  end 
end
