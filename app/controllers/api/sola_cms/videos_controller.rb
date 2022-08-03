class Api::SolaCms::VideosController < Api::SolaCms::ApiController
  before_action :set_video, only: %i[ show update destroy]

  #GET /videos
  def index
    @videos = params[:search].present? ? search_video : Video.order("#{field} #{order}")
    @videos = paginate(@videos)
    render json:  { videos: @videos }.merge(meta: pagination_details(@videos))
  end

  #POST /videos
  def create 
    @video =  Video.new(video_params)
    if @video.save
      render json: @video, status: 201
    else
      Rails.logger.info(@video.errors.messages)
      render json: {error: @video.errors.messages}, status: 400
    end
  end

  #GET /videos/:id
  def show
    render json: @video
  end

  #PUT /videos/:id
  def update
    if @video.update(video_params)
      render json: {message: "video Successfully Updated."}, status: 200
    else
      Rails.logger.info(@video.errors.messages)
      render json: {error: @video.errors.messages}, status: 400
    end 
  end 

  #DELETE /videos/:id
  def destroy
    if @video&.destroy
      render json: {message: "Video Successfully Deleted."}, status: 200
    else
      @video.errors.messages
      Rails.logger.info(@video.errors.messages)
    end
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end

  def video_params
    params.require(:video).permit(:title, :webinar, :youtube_url, :duration, :tool_id, :brand_id,  :is_introduction, :is_featured, country_ids: [], category_ids: [], tag_ids: [] )
  end

  def search_video
    Video.order("#{field} #{order}").search_video_by_columns(params[:search])
  end 
end
