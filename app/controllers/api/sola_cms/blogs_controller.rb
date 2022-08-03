class Api::SolaCms::BlogsController < Api::SolaCms::ApiController
  before_action :set_blog, only: %i[ show update destroy]

  #GET /blogs
  def index
    @blogs = params[:search].present? ? serach_blog_by_columns : Blog.order("#{field} #{order}")
    @blogs = paginate(@blogs)
    render json: { blogs: @blogs }.merge(meta: pagination_details(@blogs))
  end

  #POST /blogs
  def create  
    @blog  =  Blog.new(blog_params)
    if @blog.save
      render json: @blog, status: 200
    else
      Rails.logger.error(@blog.errors.messages)
      render json: {error: @blog.errors.messages}, status: 400     
    end
  end
  
  #GET /blogs/:id
  def show
    render json: @blog
  end

  #PUT /blogs/:id
  def update
    if @blog.update(blog_params)
      render json: {message: "Blog Successfully Updated."}, status: 200
    else
      Rails.logger.error(@blog.errors.messages)
      render json: {error: @blog.errors.messages}, status: 400
    end 
  end 

  #DELETE /blogs/:id
  def destroy
    if @blog&.destroy
      render json: {message: "Blog Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@blog.errors.messages)
      render json: {errors: format_activerecord_errors(@blog.errors) }, status: 400
    end
  end

  private

  def set_blog
    @blog = Blog.find_by(id: params[:id])
    return render(json: { error: "Record not found!"}, status: 404) unless @blog.present?
  end

  def blog_params
    params.require(:blog).permit(:title, :url_name, :canonical_url, :image, :carousel_image, :delete_image, :meta_description, :summary, :body, :author, :contact_form_visible, :status, :publish_date, :delete_carousel_image, :carousel_text, :fb_conversion_pixel, country_ids: [], tag_ids: [], category_ids: [])
  end

  def serach_blog_by_columns
    Blog.order("#{field} #{order}").search(params[:search])
  end
end
