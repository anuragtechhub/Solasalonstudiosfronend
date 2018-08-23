class NewsController < PublicWebsiteController
  def index
  	redirect_to :blog if I18n.locale.to_s == 'pt-BR'
    @articles = Article.where(:location_id => nil).order(:created_at => :desc)
  end
end
