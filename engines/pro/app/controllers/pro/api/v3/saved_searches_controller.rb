# frozen_string_literal: true

module Pro
  class Api::V3::SavedSearchesController < Api::V3::ApiController
    def index
      saved_searches = current_user.saved_searches
      saved_searches = saved_searches.where(kind: params[:kind]) if params[:kind].present?
      respond_with(paginate(saved_searches.order(updated_at: :desc)))
    end

    def create
      return if params[:q].blank?

      SavedSearch.save_for_user(current_user, params[:q], params[:kind])
    end
  end
end
