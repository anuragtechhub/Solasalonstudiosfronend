class BlogController < PublicWebsiteController
  def index
    @posts = Blog.order(:created_at => :desc).limit(20)
  end

  def show
    @post = Blog.find_by(:url_name => params[:url_name])
  end
end
