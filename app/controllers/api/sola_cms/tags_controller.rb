class Api::SolaCms::TagsController < Api::SolaCms::ApiController
  before_action :set_tag, only: %i[ show update destroy]

  #GET /tags
  def index
    @tags = Tag.all
    @tags = params[:search].present? ? search_tag : Tag.order("#{field} #{order}")
    render json: { tags: @tags } and return if params[:all] == "true"
    @tags = paginate(@tags)
    render json:  { tags: @tags }.merge(meta: pagination_details(@tags))
  end

  #POST /tags
  def create 
    @tag = Tag.new(tag_params)
    if @tag.save
      render json: @tag, status: 200
    else
      Rails.logger.error(@tag.errors.messages)
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
      Rails.logger.error(@tag.errors.messages)
      render json: {error: @tag.errors.messages}, status: 400
    end 
  end 

  #DELETE /tags/:id
  def destroy
    if @tag&.destroy
      render json: {message: "Tag Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@tag.errors.messages)
      render json: {errors: format_activerecord_errors(@tag.errors) }, status: 400
    end
  end

  private

  def set_tag
    @tag = Tag.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @tag.present?
  end

  def tag_params
    params.require(:tag).permit(:name, category_ids: [], video_ids: [], stylist_ids: [])
  end

  def search_tag
    Tag.order("#{field} #{order}").search_tag_by_attributes(params[:search])
  end 
end
