class NewsController < PublicWebsiteController
  def index
    @articles = Article.where(:location_id => nil).order(:created_at => :desc)
  end
end
