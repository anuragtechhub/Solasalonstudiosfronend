class BlogController < PublicWebsiteController
  http_basic_authenticate_with :name => "admin@solasalonstudios.com", :password => "stylists", :only => :show_preview

  def contact_form_success
    @contact_form_success = true
    @success = I18n.t('contact_form_success')
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
    render 'show'
  end


  def index
    @category = BlogCategory.find_by(:url_name => params[:category_url_name]) if params[:category_url_name].present?

    country = get_country
    if params[:category_url_name].present?
      unless @category
        @category = BlogCategory.find_by(:url_name => params[:category_url_name].split('_').join('-'))
        redirect_to(blog_category_path(:category_url_name => @category.url_name), :status => 301) if @category
      end
    end

    if @category
      # filter posts by category id
      @posts = Blog.includes(:blog_blog_categories).where(blog_blog_categories: {blog_category_id: @category.id}).where(status: 'published').joins(:blog_countries, :countries).where(countries: {code: country}).order(publish_date: :desc)
    elsif params[:query].present?
      # filter posts by search query
      query_param = "%#{params[:query].downcase.gsub(/\s/, '%')}%"
      @posts = Blog.where(status: 'published').includes(:countries).where(countries: {code: country}).where('LOWER(title) LIKE :query OR LOWER(body) LIKE :query OR LOWER(author) LIKE :query', query: query_param).order(publish_date: :desc)
    else
      # show all posts
      if I18n.locale.to_s == 'en'
        my_sola_blogs_ids = Blog.includes(:blog_blog_categories).where(blog_blog_categories: {blog_category_id: 11}).pluck(:id)
        @posts = Blog.where(status: 'published').where.not(id: my_sola_blogs_ids).includes(:countries).where(countries: {code: country}).order(publish_date: :desc)
      else
        @posts = Blog.where(status: 'published').includes(:countries).where(countries: {code: country}).order(publish_date: :desc)
      end
    end

    if @category && @category.id == 11 && I18n.locale.to_s == 'en'
      @posts = @posts.page(params[:page] || 1).per(21)
    else
      @posts = @posts.page(params[:page] || 1)
    end
    @categories = BlogCategory.order(:name)
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
