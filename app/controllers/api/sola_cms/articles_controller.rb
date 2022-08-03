# frozen_string_literal: true

class Api::SolaCms::ArticlesController < Api::SolaCms::ApiController
  before_action :set_article, only: %i[ show update destroy]

  #GET /articles
  def index
    if params[:export_csv] == "true"
      @articles = export_article_by_date
      render json: @articles and return
    end
    @articles = params[:search].present? ? search_article_by_columns : Article.order("#{field} #{order}")
    render json: { articles: @articles } and return if params[:all] == "true"
    @articles = paginate(@articles) 
    render json: { articles: @articles }.merge(meta: pagination_details(@articles))
  end

  #POST /articlesBLOCKED
  def create
    @article  =  Article.new(article_params)
    if @article.save
      render json: @article, status: 200
    else
      Rails.logger.error(@article.errors.messages)
      render json: {error: @article.errors.messages}, status: 400 
    end
  end

  #GET /articles/:id
  def show
    render json: @article
  end

  #PUT /articles/:id
  def update
    if @article.update(article_params)
      render json: {message: "Article Successfully Updated." }, status: 200
    else      Rails.logger.error(@article.errors.messages)
      render json: {error: @article.errors.messages}, status: 400
    end
  end

  #DELETE /articles/:id
  def destroy
    if @article&.destroy
      render json: {message: "Article Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@article.errors.messages)
      render json: {errors: format_activerecord_errors(@article.errors) }, status: :unprocessable_entity
    end
  end
  
  private

  def set_article
    @article = Article.find_by(id: params[:id])
    return render(json: { error: "Record not found!"}, status: 404) unless @article.present?
  end

  def article_params
    params.require(:article).permit(:title, :url_name, :summary, :body, :article_url, :image, :created_at, :location_id, :display_setting)
  end

  def export_article_by_date
    @articles = if params[:start_date] && params[:end_date].present?
      Article.where(created_at: params[:start_date].to_time..params[:end_date].to_time)
    else
      Article.all
    end
    params[:headers].present? ? @articles.map { |article| article.attributes.slice(*params[:headers]) } : @articles
  end 

  def search_article_by_columns
    Article.order("#{field} #{order}").search_article(params[:search])
  end

end
