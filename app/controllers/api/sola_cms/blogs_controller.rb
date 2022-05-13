class Api::SolaCms::BlogsController < ApiController
  skip_before_action :restrict_api_access
  before_action :set_blog, only: %i[ show update destroy]

  #GET /blogs
  def index
    @blogs = Blog.all
    render json: @blogs
  end

  #POST /blogs
  def create 
    @blog  =  Blog.new(blog_params)
    if @blog.save
      render json: @blog 
    else
      render json: {error: "Unable to Create Blog"}, status: 400
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
      render jason: {error: "Unable to Update Blog."}, status: 400
    end 
  end 

  #DELETE /blogs/:id
  def destroy
    if @blog.destroy
      render json: {message: "Blog Successfully Deleted."}, status: 200
    else
      render jason: {error: "Unable to Delete Blog."}, status: 400
    end
  end

  private

  def set_blog
    @blog = Blog.find(params[:id])
  end

  def blog_params
    params.require(:blog).permit(:title, :url_name, :canonical_url, :delete_image, :meta_description, :summary, :body, :author, :contact_form_visible, :category_ids, :tag_ids, :status, :publish_date, :delete_carousel_image, :carousel_text, :fb_conversion_pixel, :country_ids)
  end 
end
