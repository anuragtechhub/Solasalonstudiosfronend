class NewsController < PublicWebsiteController
  def index
    @articles = Article.order(:created_at => :desc)
  end
end
