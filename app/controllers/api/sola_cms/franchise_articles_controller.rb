class Api::SolaCms::FranchiseArticlesController < Api::SolaCms::ApiController
  before_action :set_franchise_article, only: %i[ show update destroy]

  #GET /franchise_articles
  def index
    @franchise_articles = params[:search].present? ? search_frachise_article : FranchiseArticle.order("#{field} #{order}")
    render json: { franchise_articles: @franchise_articles } and return if params[:all] == "true"
    @franchise_articles = paginate(@franchise_articles)
    render json:  { franchise_articles: @franchise_articles }.merge(meta: pagination_details(@franchise_articles))
  end

  #POST /franchise_articles
  def create
    @franchise_article =  FranchiseArticle.new(franchise_article_params)
    country_code = Country.find_by(id: franchise_article_params["country_id"]).code.downcase
    @franchise_article[:country] = country_code
    if @franchise_article.save
      render json: @franchise_article, status: 200
    else
      render json: {error: @franchise_article.errors.messages}, status: 400
      Rails.logger.error(@franchise_article.errors.messages)
    end 
  end 

  #GET /franchise_articles/:id
  def show
    render json: @franchise_article
  end 

  #PUT /franchise_articles/:id
  def update
    country_code = Country.find_by(id: franchise_article_params["country_id"]).code.downcase
    @franchise_article[:country] = country_code
    if @franchise_article.update(franchise_article_params)
      render json: {message: "Event and Class Successfully Updated."}, status: 200
    else
      render json: {error: @franchise_article.errors.messages}, status: 400
      Rails.logger.error(@franchise_article.errors.messages)
    end  
  end 

  #DELETE /franchise_articles/:id
  def destroy
    if @franchise_article&.destroy
      render json: {message: "Event and Class Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@franchise_article.errors.messages)
      render json: {errors: format_activerecord_errors(@franchise_article.errors) }, status: 400
    end
  end 

  private
  def set_franchise_article
    @franchise_article = FranchiseArticle.find_by(id: params[:id])
    return render(json: { error: "Record not found!"}, status: 404) unless @franchise_article.present?
  end

  def franchise_article_params
    params.require(:franchise_article).permit(:kind, :country_id, :title, :url, :thumbnail, :delete_thumbnail, :image, :delete_image, :summary, :body, :author, category_ids: [], tag_ids: [])
  end

  def search_frachise_article
    FranchiseArticle.order("#{field} #{order}").search_by_name_author_slug_and_url(params[:search])
  end
end
