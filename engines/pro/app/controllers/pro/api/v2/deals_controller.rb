# frozen_string_literal: true

module Pro
  class Api::V2::DealsController < ApiController
    def load_more
      country = get_userable_country_v2(params[:email])

      @limit = 12
      @page = params[:page].present? ? params[:page].to_i : 0

      last_updated_deal = Deal.select(:updated_at).order(updated_at: :desc).first
      last_updated_category = DealCategory.select(:updated_at).order(updated_at: :desc).first
      last_updated_brand = Brand.select(:updated_at).order(updated_at: :desc).first

      cache_key = "/api/v2/deals_load_more?country=#{country}&category_name=#{params[:category_name]}&brand_name=#{params[:brand_name]}&page=#{@page}&limit=#{@limit}&last_updated_deal=#{last_updated_deal.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

      json = Rails.cache.fetch(cache_key) do
        @brands = set_brands
        @categories = set_categories

        if params[:category_name]
          @category = DealCategory.find_by(name: params[:category_name].gsub('-', ' '))
          @deals = @category.deals.joins(:deal_countries, :countries).where(countries: { code: country }).order('LOWER(title)').group('deals.id')
        elsif params[:brand_name]
          @brand = Brand.find_by(name: params[:brand_name].gsub('-', ' '))
          @deals = Deal.joins(:deal_countries, :countries).where(countries: { code: country }).where(brand_id: @brand.id).order('LOWER(title)').group('deals.id')
        else
          @deals = Deal.joins(:deal_countries, :countries).where(countries: { code: country }).order('LOWER(title)').group('deals.id')
        end

        p "@deals=#{@deals.inspect}"

        @total_pages = if @deals&.size&.positive?
                         (@deals.size / 12) + ((@deals.size % 12).zero? ? 0 : 1)
                       else
                         0
                       end

        @deals = @deals.limit(@limit).offset(@page * @limit)

        render_to_string(formats: 'json')
      end

      render json: json
    end

    def get
      render json: Deal.find_by(id: params[:id])
    end

    private

      def set_brands
        country = get_userable_country_v2(params[:email])
        @brands = Brand.joins(:brand_countries, :countries).where(countries: { code: country }).where(id: Deal.distinct.select(:brand_id)).order('LOWER(brands.name)')
      end

      def set_categories
        country = get_userable_country_v2(params[:email])
        @categories = DealCategory.where(id: DealCategoryDeal.where(deal_id: Deal.joins(:deal_countries, :countries).where(countries: { code: country }).pluck('deals.id').uniq).pluck('deal_category_deals.deal_category_id').uniq).order('LOWER(name)')
      end
  end
end
