# frozen_string_literal: true

class Api::SolaCms::ArticlesController < Api::SolaCms::ApiController
  before_action :set_article, only: %i[ show update destroy]

  #GET /articles
  def index
    if params[:export_csv] == "true"
      @articles = if params[:start_date] && params[:end_date].present?
        Article.where(created_at: params[:start_date].to_time..params[:end_date].to_time)
      else
        Article.all
      end
      
      @articles = params[:headers].present? ? @articles.map { |m| m.attributes.slice(*params[:headers]) } : @articles
      render json: @articles and return
      
      if params[:start_date] && params[:end_date].present?
        @articles = Article.where(created_at: params[:start_date].to_time..params[:end_date].to_time)
        @articles = params[:headers].present? ? @articles.map { |m| m.attributes.slice(*params[:headers]) } : @articles
        render json: @articles and return
      else
        @articles = Article.all
      end
        @articles = Article.all
        render json: {articles: @articles}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    else
      if params[:search].present?
        @articles = Article.search_by_title_article_url(params[:search])
      else
        @articles = Article.all
        if params[:all] == "true"
          render json: { articles: @articles } and return
        end
      end
      @articles = paginate(@articles) 
      render json: { articles: @articles }.merge(meta: pagination_details(@articles))
    end 
  end

  #POST /articles
  def create
    @article  =  Article.new(article_params)
    if @article.save
      render json: @article
    else
      Rails.logger.info(@article.errors.messages)
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
    else
      Rails.logger.info(@article.errors.messages)
      render json: {error: @article.errors.messages}, status: 400
    end
  end

  #DELETE /articles/:id
  def destroy
    if @article&.destroy
      render json: {message: "Article Successfully Deleted."}, status: 200
    else
      @article.errors.messages
      Rails.logger.info(@article.errors.messages)
    end
  end
  
  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :url_name, :summary, :body, :article_url, :image, :created_at, :location_id, :display_setting)
  end
end
