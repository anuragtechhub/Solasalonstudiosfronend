require_dependency 'franchising/application_controller'

module Franchising
	class FranchiseArticlesController < ApplicationController
		def index
			@franchise_articles = FranchiseArticle.by_country_or_blank(current_country)
			@franchise_articles = @franchise_articles.search_by_query(params[:query]) if params[:query].present?
			@franchise_articles = @franchise_articles.order(id: :desc).page(params[:page])
		end

		def show
			@franchise_article = FranchiseArticle.friendly.find(params[:id])
		end

		private

		def current_country
			canadian_locale? ? :ca : :us
		end
	end
end