class Api::SolaCms::BlogsController < Api::SolaCms::ApiController
  before_action :set_blog, only: %i[ show update destroy]

  #GET /blogs
  def index
    if params[:search].present?
      blogs = Blog.search(params[:search])
      blogs = paginate(blogs)
      render json:  { blogs: blogs }.merge(meta: pagination_details(blogs))
    else  
      blogs = Blog.all
      blogs = paginate(blogs)
      render json: { blogs: blogs }.merge(meta: pagination_details(blogs))
    end
  end

  #POST /blogs
  def create  
    @blog  =  Blog.new(blog_params)
    if @blog.save
      render json: @blog 
    else
      Rails.logger.info(@blog.errors.messages)
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
      Rails.logger.info(@blog.errors.messages)
      render json: {error: @blog.errors.messages}, status: 400
    end 
  end 

  #DELETE /blogs/:id
  def destroy
    if @blog&.destroy
      render json: {message: "Blog Successfully Deleted."}, status: 200
    else
      render json: {error: @blog.errors.messages}, status: 400
      Rails.logger.info(@blog.errors.messages)
    end
  end

  private

  def set_blog
    @blog = Blog.find(params[:id])
  end

  def blog_params
    params.require(:blog).permit(:title, :url_name, :canonical_url, :image, :carousel_image, :delete_image, :meta_description, :summary, :body, :author, :contact_form_visible, :status, :publish_date, :delete_carousel_image, :carousel_text, :fb_conversion_pixel, country_ids: [], tag_ids: [], category_ids: [])
  end
end
