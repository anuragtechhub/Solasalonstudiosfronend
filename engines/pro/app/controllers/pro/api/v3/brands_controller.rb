module Pro
  class Api::V3::BrandsController < Api::V3::ApiController
    load_and_authorize_resource :brand, only: %i[show]

    def index
      @brands = Rails.cache.fetch("/api/v2/brands?country=#{current_user.location_country}") do
        Brand.includes(:countries)
             .where(countries: {code: current_user.location_country })
             .order(:name)
             .select(&:content?)
      end

      respond_with(@brands)
    end

    def show
      respond_with(@brand, serializer: Api::V3::BrandShowSerializer, include: '**')
    end
  end
end
