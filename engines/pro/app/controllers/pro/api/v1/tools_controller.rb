module Pro
  class Api::V1::ToolsController < ApiController

    #before_action :set_categories, :set_brands

    def index
      # @tools = Tool.order('LOWER(title)')
      # #@featured_tools = Tool.where(:is_featured => true).order(:created_at => :desc)

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
      #   #:featured_tools => @featured_tools,
      #   :brands => @brands,
      #   :categories => @categories
      # }
      country = get_userable_country(params[:email])

      @limit = 12
      @page = params[:page].present? ? params[:page].to_i : 0

      last_updated_tool = Tool.select(:updated_at).order(:updated_at => :desc).first
      last_updated_category = ToolCategory.select(:updated_at).order(:updated_at => :desc).first
      last_updated_brand = Brand.select(:updated_at).order(:updated_at => :desc).first

      cache_key = "/api/v1/tools?country=#{country}&page=#{@page}&limit=#{@limit}&last_updated_tool=#{last_updated_tool.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

      json = Rails.cache.fetch(cache_key) do
        @brands = set_brands
        @categories = set_categories

        @tools = Tool.order('LOWER(title)')

        if @tools && @tools.size > 0
          @total_pages = @tools.size / 12 + (@tools.size % 12 == 0 ? 0 : 1)
        else
          @total_pages = 0
        end

        @tools = @tools.limit(@limit).offset(@page * @limit)

        render_to_string(formats: 'json')
      end

      render :json => json
    end

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
      country = get_userable_country(params[:email])

      @limit = 12
      @page = params[:page].present? ? params[:page].to_i : 0

      last_updated_tool = Tool.select(:updated_at).order(:updated_at => :desc).first
      last_updated_category = ToolCategory.select(:updated_at).order(:updated_at => :desc).first
      last_updated_brand = Brand.select(:updated_at).order(:updated_at => :desc).first

      cache_key = "/api/v1/tools_load_more?country=#{country}&category_name=#{params[:category_name]}&brand_name=#{params[:brand_name]}&page=#{@page}&limit=#{@limit}&last_updated_tool=#{last_updated_tool.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

      json = Rails.cache.fetch(cache_key) do
        @brands = set_brands
        @categories = set_categories

        if params[:category_name]
          @category = ToolCategory.find_by(:name => params[:category_name].gsub('-', ' '))
          @tools = @category.tools.order('LOWER(title)')
        elsif params[:brand_name]
          @brand = Brand.find_by(:name => params[:brand_name].gsub('-', ' '))
          @tools = Tool.where(:brand_id => @brand.id).order('LOWER(title)')
        else
          @tools = Tool.order('LOWER(title)')
        end

        if @tools && @tools.size > 0
          @total_pages = @tools.size / 12 + (@tools.size % 12 == 0 ? 0 : 1)
        else
          @total_pages = 0
        end

        @tools = @tools.limit(@limit).offset(@page * @limit)

        render_to_string(formats: 'json')
      end

      render :json => json
    end

    private

    def set_brands
      country = get_userable_country(params[:email])
      @brands = Brand.where(:id => Tool.pluck(:brand_id).uniq).order('LOWER(name)')
    end

    def set_categories
      country = get_userable_country(params[:email])
      @categories = ToolCategory.where(:id => ToolCategoryTool.pluck(:tool_category_id).uniq).order(:position => :asc).order('LOWER(name)')
    end

  end
end