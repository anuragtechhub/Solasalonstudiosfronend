class BlogController < PublicWebsiteController
  http_basic_authenticate_with :name => "admin@solasalonstudios.com", :password => "stylists", :only => :show_preview

  def index
    @category = BlogCategory.find_by(:url_name => params[:category_url_name])

    country = get_country

    unless @category
      @category = BlogCategory.find_by(:url_name => params[:category_url_name].split('_').join('-')) if params[:category_url_name]
      redirect_to(blog_category_path(:category_url_name => @category.url_name), :status => 301) if @category
    end

    p "country=#{country}"
    
    if @category
      # filter posts by category id
      @posts = Blog.joins(:blog_categories, :blog_blog_categories).where('blog_blog_categories.blog_category_id = ? AND status = ?', @category.id, 'published').joins(:blog_countries, :countries).where('countries.code = ?', country).uniq.order(:publish_date => :desc)
    elsif params[:query].present?
      # filter posts by search query
      query_param = "%#{params[:query].downcase.gsub(/\s/, '%')}%"
      @posts = Blog.joins(:blog_countries, :countries).where('countries.code = ?', country).where('status = ?', 'published').where('LOWER(title) LIKE ? OR LOWER(body) LIKE ? OR LOWER(author) LIKE ?', query_param, query_param, query_param).uniq.order(:publish_date => :desc)
    else
      # show all posts
      if I18n.locale.to_s == 'en'
        @posts = Blog.joins('INNER JOIN blog_blog_categories ON blog_blog_categories.blog_id = blogs.id').where('blogs.status = ? AND blog_blog_categories.blog_category_id != ?', 'published', 11).joins(:blog_countries, :countries).where('countries.code = ?', country).uniq.order(:publish_date => :desc)
      else
        @posts = Blog.where('status = ?', 'published').joins(:blog_countries, :countries).where('countries.code = ?', country).uniq.order(:publish_date => :desc)
      end
    end

    if @category && @category.id == 11 && I18n.locale.to_s == 'en'
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
    redirect_to(show_blog_preview_path(@post), :status => 301) if @post && @post.status == 'draft'
    
    unless @post
      @post = Blog.find_by(:url_name => params[:url_name].split('_').join('-'))
      redirect_to(show_blog_path(:url_name => @post.url_name), :status => 301) if @post
    end

    p "I18n.locale=#{I18n.locale}"
    p "@post=#{@post.inspect}"

    @category = @post.blog_categories.first if @post && @post.blog_categories
    @categories = BlogCategory.order(:name => :asc)
    redirect_to(:blog, :status => 301) unless @post
  end

  def show_preview
    @post = Blog.find_by(:url_name => params[:url_name])    
    @category = @post.blog_categories.first if @post && @post.blog_categories
    @categories = BlogCategory.order(:name => :asc)
    if @post
      render 'show'
    else
      redirect_to :blog, :status => 301
    end
  end

  private

  def get_country
    # if request.domain == 'solasalonstudios.ca'
    #   return 'CA' 
    # else
    #   return 'US'
    # end
    if request.domain == 'solasalonstudios.ca' #|| request.domain == 'localhost'
      return 'CA'
    elsif request.domain == 'com.br' || request.domain == 'com.br/' #|| request.domain == 'localhost'
      return 'BR'
    else
      return 'US'
    end    
  end

end
