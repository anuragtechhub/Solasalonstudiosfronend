class BlogController < PublicWebsiteController
  http_basic_authenticate_with :name => "admin@solasalonstudios.com", :password => "stylists", :only => :show_preview

  def index
    @category = BlogCategory.find_by(:url_name => params[:category_url_name])

    unless @category
      @category = BlogCategory.find_by(:url_name => params[:category_url_name].split('_').join('-')) if params[:category_url_name]
      redirect_to blog_category_path(:category_url_name => @category.url_name) if @category
    end
    
    if @category
      # filter posts by category id
      @posts = Blog.joins(:blog_categories, :blog_blog_categories).where('blog_blog_categories.blog_category_id = ? AND status = ?', @category.id, 'published').uniq.order(:publish_date => :desc)
    elsif params[:query].present?
      # filter posts by search query
      query_param = "%#{params[:query].downcase.gsub(/\s/, '%')}%"
      @posts = Blog.where('status = ?', 'published').where('LOWER(title) LIKE ? OR LOWER(body) LIKE ? OR LOWER(author) LIKE ?', query_param, query_param, query_param).order(:publish_date => :desc)
    else
      # show all posts
      @posts = Blog.joins('INNER JOIN blog_blog_categories ON blog_blog_categories.blog_id = blogs.id').where('blogs.status = ? AND blog_blog_categories.blog_category_id != ?', 'published', 11).uniq.order(:publish_date => :desc)
    end

    if @category && @category.id == 11
      @posts = @posts.page(params[:page] || 1).per(21)
    else
      @posts = @posts.page(params[:page] || 1)
    end
    @categories = BlogCategory.order(:name => :asc)

    @last_blog = Blog.order(:publish_date => :desc).first
    @last_category = BlogCategory.order(:updated_at => :desc).first
    @last_blog_category = BlogBlogCategory.order(:updated_at => :desc).first
  end

  def show
    @post = Blog.find_by(:url_name => params[:url_name])
    redirect_to show_blog_preview_path(@post) if @post && @post.status == 'draft'
    
    unless @post
      @post = Blog.find_by(:url_name => params[:url_name].split('_').join('-'))
      redirect_to show_blog_path(:url_name => @post.url_name) if @post
    end

    @category = @post.blog_categories.first if @post && @post.blog_categories
    @categories = BlogCategory.order(:name => :asc)
    redirect_to :blog unless @post
  end

  def show_preview
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
