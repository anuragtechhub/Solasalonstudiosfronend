# frozen_string_literal: true

class ArticleController < PublicWebsiteController
  def show
    # @article = Article.find_by(:url_name => params[:url_name])
    redirect_to :news, status: :moved_permanently
  end
end
