class Api::SolaCms::TagsController < Api::SolaCms::ApiController
  before_action :set_tag, only: %i[ show update destroy]

  #GET /tags
  def index
    @tags = Tag.all
    render json: @tags
  end

  #POST /tags
  def create 
    @tag  =  Tag.new(tag_params)
    if @tag.save
      render json: @tag 
    else
      Rails.logger.info(@tag.errors.messages)
      render json: {error: @tag.errors.messages}, status: 400
    end
  end

  #GET /tags/:id
  def show
    render json: @tag
  end

  #PUT /tags/:id
  def update
    if @tag.update(tag_params)
      render json: {message: "Tag Successfully Updated."}, status: 200
    else
      Rails.logger.info(@tag.errors.messages)
      render json: {error: @tag.errors.messages}, status: 400
    end 
  end 

  #DELETE /tags/:id
  def destroy
    if @tag.destroy
      render json: {message: "Tag Successfully Deleted."}, status: 200
    else
      Rails.logger.info(@tag.errors.messages)
      render json: {error: @tag.errors.messages}, status: 400
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end 
end
