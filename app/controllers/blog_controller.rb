class BlogController < PublicWebsiteController
  http_basic_authenticate_with :name => "admin@solasalonstudios.com", :password => "stylists", :only => :show_preview
  before_action :categories
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

    @category = @post.categories.first if @post && @post.categories
    redirect_to(:blog, :status => 301) unless @post
    render 'show'
  end


  def index
    @category = Category.find_by(:slug => params[:category_url_name]) if params[:category_url_name].present?
    @posts = Blog.published.by_country(get_country)
    # filter posts by category id
    @posts = @posts.by_category(@category.id) if @category.present?
    # filter posts by search query
    @posts = @posts.search_by_query(params[:query]) if params[:query].present?
    @posts = @posts.order(publish_date: :desc).page(params[:page] || 1)
  end

  def show
    @post = Blog.find_by(url_name: params[:url_name])
    redirect_to(show_blog_preview_path(@post), :status => 301) if @post && @post.status == 'draft'

    unless @post
      @post = Blog.find_by(:url_name => params[:url_name].split('_').join('-'))
      redirect_to(show_blog_path(:url_name => @post.url_name), :status => 301) if @post
    end

    p "I18n.locale=#{I18n.locale}"
    p "@post=#{@post.inspect}"

    @category = @post.categories.first if @post && @post.categories
    redirect_to(:blog, :status => 301) unless @post
  end

  def show_preview
    @post = Blog.find_by(:url_name => params[:url_name])
    @category = @post.categories.first if @post && @post.categories
    if @post
      render 'show'
    else
      redirect_to :blog, :status => 301
    end
  end

  private

  def categories
    @categories = Category.includes(:categoriables).
      where(categoriables: {item_type: 'Blog'}).
      order(:name)
  end

  def get_country
    if request.domain == 'solasalonstudios.ca'
      return 'CA'
    elsif request.domain == 'com.br' || request.domain == 'com.br/'
      return 'BR'
    else
      return 'US'
    end
  end

end
