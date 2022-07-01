class Api::SolaCms::FranchiseArticlesController < Api::SolaCms::ApiController
  before_action :set_franchise_article, only: %i[ show update destroy]

  #GET /franchise_articles
  def index
    if params[:search].present?
      franchise_articles = FranchiseArticle.search_by_name_author_slug_and_url(params[:search])
      franchise_articles = paginate(franchise_articles)
      render json:  { franchise_articles: franchise_articles }.merge(meta: pagination_details(franchise_articles))
    else  
      franchise_articles = FranchiseArticle.all
      franchise_articles = paginate(franchise_articles)
      render json: { franchise_articles: franchise_articles }.merge(meta: pagination_details(franchise_articles))
    end
  end

  #POST /franchise_articles
  def create
    @franchise_article =  FranchiseArticle.new(franchise_article_params)
    if @franchise_article.save
      render json: @franchise_article
    else
      render json: {error: @franchise_article.errors.messages}, status: 400
      Rails.logger.info(@franchise_article.errors.messages)
    end 
  end 

  #GET /franchise_articles/:id
  def show
    render json: @franchise_article
  end 

  #PUT /franchise_articles/:id
  def update
    if @franchise_article.update(franchise_article_params)
      render json: {message: "Event and Class Successfully Updated."}, status: 200
    else
      render json: {error: @franchise_article.errors.messages}, status: 400
      Rails.logger.info(@franchise_article.errors.messages)
    end  
  end 

  #DELETE /franchise_articles/:id
  def destroy
    if @franchise_article&.destroy
      render json: {message: "Event and Class Successfully Deleted."}, status: 200
    else
      @franchise_article.errors.messages
      Rails.logger.info(@franchise_article.errors.messages)
    end
  end 

  private
  def set_franchise_article
    @franchise_article = FranchiseArticle.find(params[:id])
  end

  def franchise_article_params
    params.require(:franchise_article).permit(:kind, :country, :title, :url, :thumbnail, :delete_thumbnail, :image, :delete_image, :summary, :body, :author, category_ids: [], tag_ids: [])
  end
end
