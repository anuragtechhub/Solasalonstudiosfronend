class ArticleController < ApplicationController
  def show
    @post = Article.find_by(:url_name => params[:url_name])
  end
end
