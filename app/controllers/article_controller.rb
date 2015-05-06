class ArticleController < PublicWebsiteController
  def show
    @article = Article.find_by(:url_name => params[:url_name])
  end
end
