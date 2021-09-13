require_dependency 'franchising/application_controller'

module Franchising
  class WebsiteController < ApplicationController
    before_action :set_show_franchise_form, only: %i[
      why_sola our_story in_the_news learn_more
    ]

    def index
    end

    def in_the_news
      @articles = Article.where('location_id IS NULL AND display_setting != ?', 'sola_website').order(:created_at => :desc)
    end

    def learn_more
    end

    def our_story
    end

    def privacy_policy
    end

    def ada
    end

    def why_sola
    end

    def thank_you
    end

    private

    def set_show_franchise_form
      @show_franchise_form = true
    end
  end
end
