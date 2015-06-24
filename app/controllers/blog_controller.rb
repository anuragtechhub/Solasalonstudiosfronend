class BlogController < PublicWebsiteController
  http_basic_authenticate_with :name => "admin@solasalonstudios.com", :password => "stylists", :only => :show_draft

  def index
    @category = BlogCategory.find_by(:url_name => params[:category_url_name])
    if @category
      #filter posts by category id
      @posts = Blog.joins(:blog_categories, :blog_blog_categories).where('blog_blog_categories.blog_category_id = ? AND status = ?', @category.id, 'published').uniq.order(:publish_date => :desc)
    else
      @posts = Blog.where('status = ?', 'published').order(:publish_date => :desc)
    end
    @categories = BlogCategory.order(:name => :asc)

    @last_blog = Blog.order(:publish_date => :desc).first
    @last_category = BlogCategory.order(:updated_at => :desc).first
    @last_blog_category = BlogBlogCategory.order(:updated_at => :desc).first
  end

  def show
    @post = Blog.find_by(:url_name => params[:url_name])
    redirect_to show_blog_draft_path(@post) if @post && @post.status == 'draft'
    
    @category = @post.blog_categories.first if @post && @post.blog_categories
    @categories = BlogCategory.order(:name => :asc)
    redirect_to :blog unless @post
  end

  def show_draft
    @post = Blog.find_by(:url_name => params[:url_name])    
    @category = @post.blog_categories.first if @post && @post.blog_categories
    @categories = BlogCategory.order(:name => :asc)
    if @post
      render 'show'
    else
      redirect_to :blog 
    end
  end
end
