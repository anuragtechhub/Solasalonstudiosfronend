# frozen_string_literal: true

module Pro
  class Api::V2::BrandsController < ApiController
    def index
      country = get_userable_country(params[:email])
      @country = country

      last_updated_brand = Brand.select(:updated_at).order(updated_at: :desc).first
      cache_key = "/api/v2/brands?country=#{country}&last_updated=#{last_updated_brand.updated_at}"

      json = Rails.cache.fetch(cache_key) do
        @brands = []

        Brand.joins(:brand_countries, :countries).where(countries: { code: country }).order('brands.name ASC').group('brands.id').each do |brand|
          @brands << brand if brand.content?
        end

        render_to_string(formats: 'json')
      end

      render json: json
    end

    def get
      render json: Brand.find_by(id: params[:id])
    end

    def show
      # @brand = Brand.find_by(:name => params[:brand_name].gsub('-', ' '))
      # @deals = Deal.where(:brand_id => @brand.id).order(:title => :asc)
      # @classes = SolaClass.where(:brand_id => @brand.id).where('end_date >= ?', Date.today).order(:title => :asc)
      # @videos = Video.where(:brand_id => @brand.id).order(:title => :asc).order("is_introduction != TRUE")
      # @tools = Tool.where(:brand_id => @brand.id).order(:title => :asc)

      # render :json => {
      #   :brand => @brand,
      #   :deals => @deals,
      #   :classes => @classes,
      #   :videos => @videos,
      #   :tools => @tools
      # }
    end
  end
end
