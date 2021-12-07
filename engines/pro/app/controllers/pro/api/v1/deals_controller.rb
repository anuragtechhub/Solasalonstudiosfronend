module Pro
  class Api::V1::DealsController < ApiController

    def index
      country = get_userable_country(params[:email])

      @limit = 12
      @page = params[:page].present? ? params[:page].to_i : 0

      last_updated_deal = Deal.select(:updated_at).order(:updated_at => :desc).first
      last_updated_category = DealCategory.select(:updated_at).order(:updated_at => :desc).first
      last_updated_brand = Brand.select(:updated_at).order(:updated_at => :desc).first

      cache_key = "/api/v1/deals?country=#{country}&page=#{@page}&limit=#{@limit}&last_updated_deal=#{last_updated_deal.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

      json = Rails.cache.fetch(cache_key) do
        @brands = set_brands
        @categories = set_categories

        @deals = Deal.order('LOWER(title)')
        if @deals && @deals.size > 0
          @total_pages = @deals.size / 12 + (@deals.size % 12 == 0 ? 0 : 1)
        else
          @total_pages = 0
        end
        @deals = @deals.limit(@limit).offset(@page * @limit)

        render_to_string(formats: 'json')
      end

      render :json => json
    end

    def load_more
      country = get_userable_country(params[:email])

      @limit = 12
      @page = params[:page].present? ? params[:page].to_i : 0

      last_updated_deal = Deal.select(:updated_at).order(:updated_at => :desc).first
      last_updated_category = DealCategory.select(:updated_at).order(:updated_at => :desc).first
      last_updated_brand = Brand.select(:updated_at).order(:updated_at => :desc).first

      cache_key = "/api/v1/deals_load_more?country=#{country}&category_name=#{params[:category_name]}&brand_name=#{params[:brand_name]}&page=#{@page}&limit=#{@limit}&last_updated_deal=#{last_updated_deal.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

      json = Rails.cache.fetch(cache_key) do
        @brands = set_brands
        @categories = set_categories

        if params[:category_name]
          @category = DealCategory.find_by(:name => params[:category_name].gsub('-', ' '))
          @deals = @category.deals.order('LOWER(title)')
        elsif params[:brand_name]
          @brand = Brand.find_by(:name => params[:brand_name].gsub('-', ' '))
          @deals = Deal.where(:brand_id => @brand.id).order('LOWER(title)')
        else
          @deals = Deal.order('LOWER(title)')
        end

        if @deals && @deals.size > 0
          @total_pages = @deals.size / 12 + (@deals.size % 12 == 0 ? 0 : 1)
        else
          @total_pages = 0
        end

        @deals = @deals.limit(@limit).offset(@page * @limit)

        render_to_string(formats: 'json')
      end

      render :json => json
    end

    def get
      render :json => Deal.find_by(:id => params[:id])
    end

    private

    def set_brands
      country = get_userable_country(params[:email])
      @brands = Brand.where(:id => Deal.pluck(:brand_id).uniq).order('LOWER(name)')
    end

    def set_categories
      country = get_userable_country(params[:email])
      @categories = DealCategory.where(:id => DealCategoryDeal.pluck(:deal_category_id).uniq).order(:position => :asc).order('LOWER(name)')
    end

  end
end