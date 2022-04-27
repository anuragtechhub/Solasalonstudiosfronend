# frozen_string_literal: true

module Pro
  class Api::V3::BrandsController < Api::V3::ApiController
    load_and_authorize_resource :brand, only: %i[show]

    def index
      @brands = Brand.select(:id, :name)
        .with_content.joins(:countries)
        .where(countries: { code: current_user.location_country })
        .order(:name)

      respond_with(@brands)
    end

    def show
      respond_with(@brand, serializer: Api::V3::BrandShowSerializer, include: '**')
    end
  end
end
