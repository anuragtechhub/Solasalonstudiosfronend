# frozen_string_literal: true

module Pro
  class Api::V3::SearchController < Api::V3::ApiController
    def index
      respond_with(paginate(PgSearchDocument.select('DISTINCT content').where('content ILIKE ?', "#{params[:q]}%")))
    end
  end
end
