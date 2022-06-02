# frozen_string_literal: true

class Api::SolaCms::ArticlesController < Api::SolaCms::ApiController
  before_action :set_article, only: %i[ show update destroy]


  #GET /articles
  def index
    @articles = Article.all
    render json: @articles
  end

  #POST /articles
  def create
    @article  =  Article.new(article_params)
    if @article.save
      render json: @article
    else
      render json: {error: "Unable to Create Article " }, status: 400 
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
      render json: {error: "Unable to Update Article."}, status: 400
    end
  end

  #DELETE /articles/:id
  def destroy
    if @article.destroy
      render json: {message: "Article Successfully Deleted."}, status: 200
    else
      render json: {error: "Unable to Delete Article."}, status: 400
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
