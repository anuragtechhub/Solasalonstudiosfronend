class BlogController < PublicWebsiteController
  def index
    p "BlogController #{params[:category_url_name]}"
    @category = BlogCategory.find_by(:url_name => params[:category_url_name])
    p "@category=#{@category}"
    if @category
      #filter posts by category id
      p "going to filter by category id"
      @posts = Blog.joins(:blog_categories, :blog_blog_categories).where('blog_blog_categories.blog_category_id = ?', @category.id).uniq.order(:created_at => :desc)
    else
      p "not going to filter by category"
      @posts = Blog.order(:created_at => :desc)
    end
    @categories = BlogCategory.order(:name => :asc)

    @last_blog = Blog.order(:updated_at => :desc).first
    @last_category = BlogCategory.order(:updated_at => :desc).first
    @last_blog_category = BlogBlogCategory.order(:updated_at => :desc).first
  end

  def show
    @post = Blog.find_by(:url_name => params[:url_name])
    @category = @post.blog_categories.first if @post && @post.blog_categories
    @categories = BlogCategory.order(:name => :asc)
  end
end
