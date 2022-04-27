# frozen_string_literal: true

module Pro
  class Api::V2::ToolsController < ApiController
    # before_action :set_categories, :set_brands

    # def index
    #   # @tools = Tool.order('LOWER(title)')
    #   # #@featured_tools = Tool.where(:is_featured => true).order(:created_at => :desc)

    #   # if @tools && @tools.size > 0
    #   #   @total_pages = @tools.size / 12 + (@tools.size % 12 == 0 ? 0 : 1)
    #   # else
    #   #   @total_pages = 0
    #   # end

    #   # @limit = 12
    #   # @page = params[:page].present? ? params[:page].to_i : 0
    #   # @tools = @tools.limit(@limit).offset(@page * @limit)

    #   # render :json => {
    #   #   :total_pages => @total_pages,
    #   #   :tools => @tools,
    #   #   #:featured_tools => @featured_tools,
    #   #   :brands => @brands,
    #   #   :categories => @categories
    #   # }
    #   country = get_userable_country_v2(params[:email])

    #   @limit = 12
    #   @page = params[:page].present? ? params[:page].to_i : 0

    #   last_updated_tool = Tool.select(:updated_at).order(:updated_at => :desc).first
    #   last_updated_category = ToolCategory.select(:updated_at).order(:updated_at => :desc).first
    #   last_updated_brand = Brand.select(:updated_at).order(:updated_at => :desc).first

    #   cache_key = "/api/v2/tools?country=#{country}&page=#{@page}&limit=#{@limit}&last_updated_tool=#{last_updated_tool.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

    #   json = Rails.cache.fetch(cache_key) do
    #     @brands = set_brands
    #     @categories = set_categories

    #     @tools = Tool.order('LOWER(title)')

    #     if @tools && @tools.size > 0
    #       @total_pages = @tools.size / 12 + (@tools.size % 12 == 0 ? 0 : 1)
    #     else
    #       @total_pages = 0
    #     end

    #     @tools = @tools.limit(@limit).offset(@page * @limit)

    #     render_to_string(formats: 'json')
    #   end

    #   render :json => json
    # end

    def load_more
      # if params[:category_name]
      #   @category = ToolCategory.find_by(:name => params[:category_name].gsub('-', ' '))
      #   @tools = @category.tools.order('LOWER(title)')
      # elsif params[:brand_name]
      #   @brand = Brand.find_by(:name => params[:brand_name].gsub('-', ' '))
      #   @tools = Tool.where(:brand_id => @brand.id).order('LOWER(title)')
      # else
      #   @tools = Tool.order('LOWER(title)')
      # end

      # if @tools && @tools.size > 0
      #   @total_pages = @tools.size / 12 + (@tools.size % 12 == 0 ? 0 : 1)
      # else
      #   @total_pages = 0
      # end

      # @limit = 12
      # @page = params[:page].present? ? params[:page].to_i : 0
      # @tools = @tools.limit(@limit).offset(@page * @limit)

      # render :json => {
      #   :total_pages => @total_pages,
      #   :tools => @tools,
      #   :brands => @brands,
      #   :categories => @categories
      # }
      country = get_userable_country_v2(params[:email])

      @limit = 12
      @page = params[:page].present? ? params[:page].to_i : 0

      last_updated_tool = Tool.select(:updated_at).order(updated_at: :desc).first
      last_updated_category = ToolCategory.select(:updated_at).order(updated_at: :desc).first
      last_updated_brand = Brand.select(:updated_at).order(updated_at: :desc).first

      cache_key = "/api/v2/tools_load_more?country=#{country}&category_name=#{params[:category_name]}&brand_name=#{params[:brand_name]}&page=#{@page}&limit=#{@limit}&last_updated_tool=#{last_updated_tool.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

      json = Rails.cache.fetch(cache_key) do
        @brands = set_brands
        @categories = set_categories

        if params[:category_name]
          @category = ToolCategory.find_by(name: params[:category_name].gsub('-', ' '))
          # @tools = @category.tools.joins(:tool_countries, :countries).where('countries.code = ?', country).order('LOWER(title)').group('tools.id')
          @tools = @category.tools.order('LOWER(title)').group('tools.id')
        elsif params[:brand_name]
          @brand = Brand.find_by(name: params[:brand_name].gsub('-', ' '))
          @tools = Tool.joins(:tool_countries, :countries).where(countries: { code: country }).where(brand_id: @brand.id).order(created_at: :desc).group('tools.id')
        else
          @tools = Tool.joins(:tool_countries, :countries).where(countries: { code: country }).order(created_at: :desc).group('tools.id')
        end

        p "tools=#{@tools.inspect}"

        @total_pages = if @tools&.size&.positive?
                         (@tools.size / 12) + ((@tools.size % 12).zero? ? 0 : 1)
                       else
                         0
                       end

        @tools = @tools.limit(@limit).offset(@page * @limit)

        render_to_string(formats: 'json')
      end

      render json: json
    end

    private

      def set_brands
        country = get_userable_country_v2(params[:email])
        # @brands = Brand.joins(:brand_countries, :countries).where('countries.code = ?', country).where(:id => Tool.pluck(:brand_id).uniq).order('LOWER(brands.name)')
        @brands = Brand.where(id: Tool.joins(:tool_countries, :countries).where(countries: { code: country }).where(countries: { code: country }).pluck(:brand_id).uniq).order('LOWER(brands.name)')
      end

      def set_categories
        country = get_userable_country_v2(params[:email])
        # @categories = ToolCategory.where(:id => ToolCategoryTool.where(:tool_id => Tool.joins(:tool_countries, :countries).where('countries.code = ?', country).pluck('tools.id').uniq).pluck('tool_category_tools.tool_category_id').uniq).order('LOWER(name)')
        @categories = ToolCategory.where(id: ToolCategoryTool.where(tool_id: Tool.joins(:tool_countries, :countries).where(countries: { code: country }).pluck('tools.id').uniq).pluck('tool_category_tools.tool_category_id').uniq).order('LOWER(name)')
      end
  end
end
