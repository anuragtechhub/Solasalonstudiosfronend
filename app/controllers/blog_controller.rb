class BlogController < PublicWebsiteController
  def index
    @category = BlogCategory.find_by(:url_name => params[:category_url_name])
    if @category
      #filter posts by category id
      @posts = Blog.joins(:blog_categories, :blog_blog_categories).where('blog_blog_categories.blog_category_id = ?', @category.id).uniq.order(:created_at => :desc)
    else
      @posts = Blog.order(:created_at => :desc)
    end
    @categories = BlogCategory.order(:name => :asc)
  end

  def show
    @post = Blog.find_by(:url_name => params[:url_name])
    @category = @post.blog_categories.first if @post && @post.blog_categories
    @categories = BlogCategory.order(:name => :asc)
  end
end
