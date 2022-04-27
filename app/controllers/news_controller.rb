# frozen_string_literal: true

class NewsController < PublicWebsiteController
  def index
    # redirect_to :blog if I18n.locale.to_s == 'pt-BR'
    @articles = Article.where('location_id IS NULL AND display_setting != ?', 'franchising').order(created_at: :desc)
  end
end
