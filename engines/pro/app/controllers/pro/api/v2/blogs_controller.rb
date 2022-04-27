# frozen_string_literal: true

module Pro
  class Api::V2::BlogsController < ApiController
    before_action :set_categories

    # def index
    #   last_updated_blog = Blog.select(:updated_at).order(:updated_at => :desc).first
    #   last_updated_category = BlogCategory.select(:updated_at).order(:updated_at => :desc).first
    #   @limit = params[:limit].present? ? params[:limit].to_i : 12
    #   @page = params[:page].present? ? params[:page].to_i : 0
    #   cache_key = "/api/v1/blogs?last_updated_blog=#{last_updated_blog.updated_at}&last_updated_category=#{last_updated_category.updated_at}&page=#{@page}&limit=#{@limit}"

    #   json = Rails.cache.fetch(cache_key) do
    #     @blogs = Blog.joins('INNER JOIN blog_blog_categories ON blog_blog_categories.blog_id = blogs.id').where('blogs.status = ? AND blog_blog_categories.blog_category_id != ?', 'published', 11).uniq.order(:publish_date => :desc)

    #     if @blogs && @blogs.size > 0
    #       @total_pages = @blogs.size / @limit + (@blogs.size % @limit == 0 ? 0 : 1)
    #     else
    #       @total_pages = 0
    #     end

    #     @blogs = @blogs.limit(@limit).offset(@page * @limit)

    #     render_to_string(formats: 'json')
    #   end

    #   render :json => json
    # end

    def load_more
      country = get_userable_country_v2(params[:email])
      @limit = 12
      @page = params[:page].present? ? params[:page].to_i : 0

      p "load more blogs #{country}, email=#{params[:email]}"

      last_updated_blog = Blog.select(:updated_at).order(updated_at: :desc).first
      last_updated_category = BlogCategory.select(:updated_at).order(updated_at: :desc).first
      cache_key = "/api/v2/blogs_load_more?country=#{country}&last_updated_blog=#{last_updated_blog.updated_at}&last_updated_category=#{last_updated_category.updated_at}&page=#{@page}&limit=#{@limit}&category_name=#{params[:category_name]}"

      json = Rails.cache.fetch(cache_key) do
        if params[:category_name]
          @category = BlogCategory.find_by(name: params[:category_name])
          @blogs = Blog.joins('INNER JOIN blog_blog_categories ON blog_blog_categories.blog_id = blogs.id').where('blog_blog_categories.blog_category_id = ? AND status = ?', @category.id, 'published').uniq.order(publish_date: :desc)
        else
          @blogs = Blog.joins('INNER JOIN blog_blog_categories ON blog_blog_categories.blog_id = blogs.id').joins(:blog_countries, :countries).where(countries: { code: country }).where('blogs.status = ? AND blog_blog_categories.blog_category_id != ?', 'published', 11).uniq.order('blogs.publish_date DESC')
        end

        p "@blogs=#{@blogs.length}, #{@blogs.inspect}"

        @total_pages = if @blogs&.size&.positive?
                         (@blogs.size / 12) + ((@blogs.size % 12).zero? ? 0 : 1)
                       else
                         0
                       end

        @blogs = @blogs.limit(@limit).offset(@page * @limit)

        render_to_string(formats: 'json')
      end

      render json: json
    end

    def search
      render json: search_blogs(params[:query])
    end

    private

      def search_blogs(query)
        return [] unless query&.present?

        blogs = []
        query_param = "%#{query.downcase.gsub(/\s/, '%')}%"

        Blog.where('LOWER(title) LIKE ? OR LOWER(body) LIKE ? OR LOWER(author) LIKE ?', query_param, query_param, query_param).order(publish_date: :desc)

        # BlogCategory.where('LOWER(name) LIKE ?', query_param).each do |category|
        #   category.blogs.each do |blog|
        #     blogs << blog unless blogs.include?(blog)
        #   end
        # end

        # video_tags = Tag.where('LOWER(name) LIKE ?', query_param).each do |tag|
        #   tag.videos.each do |video|
        #     blogs << video unless blogs.include?(video)
        #   end
        # end

        # .uniq#.sort{|a, b| a.created_at <=> b.created_at }
      end

      def set_categories
        @categories = BlogCategory.order(name: :asc)
      end
  end
end
