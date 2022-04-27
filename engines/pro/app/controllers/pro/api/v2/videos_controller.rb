# frozen_string_literal: true

module Pro
  class Api::V2::VideosController < ApiController
    # before_action :set_categories, :set_brands

    def load_more
      country = get_userable_country_v2(params[:email])

      @limit = 12
      @page = params[:page].present? ? params[:page].to_i : 0

      last_updated_video = Video.select(:updated_at).order(updated_at: :desc).first
      last_updated_category = VideoCategory.select(:updated_at).order(updated_at: :desc).first
      last_updated_brand = Brand.select(:updated_at).order(updated_at: :desc).first
      last_updated_video_view = VideoView.select(:updated_at).order(updated_at: :desc).first

      cache_key = "/api/v2/videos_load_more?country=#{country}&category_name=#{params[:category_name]}&last_updated_view_view=#{last_updated_video_view.updated_at}&brand_name=#{params[:brand_name]}&page=#{@page}&limit=#{@limit}&last_updated_video=#{last_updated_video.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

      json = Rails.cache.fetch(cache_key) do
        @brands = set_brands
        @categories = set_categories

        if params[:category_name]
          @category = VideoCategory.find_by(name: params[:category_name].gsub('-', ' '))
          # @videos = @category.videos.joins(:video_countries, :countries).where('countries.code = ?', country).where(:is_introduction => false).order('created_at DESC').group('videos.id')#.order('LOWER(title)')
          @videos = @category.videos.where(is_introduction: false).order('created_at DESC').group('videos.id')
        elsif params[:brand_name]
          @brand = Brand.find_by(name: params[:brand_name].gsub('-', ' '))
          # p "@brand=#{@brand.inspect}, coutnry=#{country}"
          @videos = Video.joins(:video_countries, :countries).where(countries: { code: country }).where(videos: { is_introduction: false }).where(videos: { brand_id: @brand.id }).order('videos.created_at DESC').group('videos.id') # .order('LOWER(title)')
        else
          @videos = Video.joins(:video_countries, :countries).where(countries: { code: country }).where(videos: { is_introduction: false }).order('videos.created_at DESC').group('videos.id') # .order('LOWER(title)')
        end

        p "videos=#{@videos.inspect}"

        @total_pages = if @videos&.size&.positive?
                         (@videos.size / 12) + ((@videos.size % 12).zero? ? 0 : 1)
                       else
                         0
                       end

        @videos = @videos.limit(@limit).offset(@page * @limit)

        render_to_string(formats: 'json')
      end

      render json: json
    end

    def history_load_more
      @limit = 12
      @page = params[:page].present? ? params[:page].to_i : 0

      # last_updated_video = Video.select(:updated_at).order(:updated_at => :desc).first
      # last_updated_category = VideoCategory.select(:updated_at).order(:updated_at => :desc).first
      # last_updated_brand = Brand.select(:updated_at).order(:updated_at => :desc).first
      # last_updated_video_view = VideoView.select(:updated_at).order(:updated_at => :desc).first

      # cache_key = "/api/v1/video_history_load_more?category_name=#{params[:category_name]}&last_updated_view_view=#{last_updated_video_view.updated_at}&brand_name=#{params[:brand_name]}&page=#{@page}&limit=#{@limit}&last_updated_video=#{last_updated_video.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

      # json = Rails.cache.fetch(cache_key) do
      userable = get_user(params[:email])
      @videos = VideoView.where(id: VideoView.select('DISTINCT ON (video_id) *').where(userable_id: userable.id, userable_type: userable.class.name).map(&:id)).order(created_at: :desc)

      @total_pages = if @videos&.size&.positive?
                       (@videos.size / 12) + ((@videos.size % 12).zero? ? 0 : 1)
                     else
                       0
                     end

      @videos = @videos.limit(@limit).offset(@page * @limit)

      @videos = @videos.map(&:video)

      json = render_to_string('load_more', formats: 'json')
      # end

      render json: json
    end

    def watch_later_load_more
      @limit = 12
      @page = params[:page].present? ? params[:page].to_i : 0

      # last_updated_video = Video.select(:updated_at).order(:updated_at => :desc).first
      # last_updated_category = VideoCategory.select(:updated_at).order(:updated_at => :desc).first
      # last_updated_brand = Brand.select(:updated_at).order(:updated_at => :desc).first
      # last_updated_video_view = VideoView.select(:updated_at).order(:updated_at => :desc).first

      # cache_key = "/api/v1/video_history_load_more?category_name=#{params[:category_name]}&last_updated_view_view=#{last_updated_video_view.updated_at}&brand_name=#{params[:brand_name]}&page=#{@page}&limit=#{@limit}&last_updated_video=#{last_updated_video.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

      # json = Rails.cache.fetch(cache_key) do
      userable = get_user(params[:email])
      @videos = WatchLater.where(userable_id: userable.id, userable_type: userable.class.name).order(created_at: :desc)

      @total_pages = if @videos&.size&.positive?
                       (@videos.size / 12) + ((@videos.size % 12).zero? ? 0 : 1)
                     else
                       0
                     end

      @videos = @videos.limit(@limit).offset(@page * @limit)

      @videos = @videos.map(&:video)

      json = render_to_string('load_more', formats: 'json')
      # end

      render json: json
    end

    def search
      render json: search_videos(params[:query])
    end

    def recommended; end

    def log_view
      userable = get_user(params[:email])

      if userable
        VideoView.create(video_id: params[:video_id], userable_id: userable.id, userable_type: userable.class.name)
      end

      render json: { video_history_data: userable.video_history_data }
    end

    def watch_later
      userable = get_user(params[:email])

      if userable
        watchLater = WatchLater.find_by(video_id: params[:video_id], userable_id: userable.id, userable_type: userable.class.name)
        if watchLater
          watchLater.destroy
        else
          WatchLater.create(video_id: params[:video_id], userable_id: userable.id, userable_type: userable.class.name)
        end
      end

      render json: { watch_later_data: userable.watch_later_data, watch_later_video_ids: userable.watch_later_video_ids }
    end

    def get
      render json: Video.find_by(id: params[:id])
    end

    private

      def recommended_videos(video); end

      def search_videos(query)
        return [] unless query&.present?

        country = get_userable_country_v2(params[:email])
        videos = []
        query_param = "%#{query.downcase.gsub(/\s/, '%')}%"

        @brands = set_brands
        @categories = set_categories

        Video.joins(:video_countries, :countries).where(countries: { code: country }).where('LOWER(videos.title) LIKE ? OR LOWER(videos.title) = ?', query_param, query.downcase).each do |video|
          videos << video # unless videos.include?(video)
        end

        if @brands&.size&.positive?
          @brands.where('LOWER(name) LIKE ? OR LOWER(name) = ?', query_param, query.downcase).each do |brand|
            brand.videos.each do |video|
              videos << video
            end
          end
        end

        if @categories&.size&.positive?
          @categories.where('LOWER(name) LIKE ? OR LOWER(name) = ?', query_param, query.downcase).each do |category|
            category.videos.each do |video|
              videos << video # unless videos.include?(video)
            end
          end
        end

        videos.sort { |a, b| a.created_at <=> b.created_at }

        video_tags = Tag.where('LOWER(name) LIKE ? OR LOWER(name) = ?', query_param, query.downcase).each do |tag|
          # p "lets filter by tag #{tag.inspect}"
          tag.videos.each do |video|
            videos << video # unless videos.include?(video)
          end
        end

        videos.uniq # .sort{|a, b| a.created_at <=> b.created_at }
      end

      def set_brands
        country = get_userable_country_v2(params[:email])
        # @brands = Brand.joins(:brand_countries, :countries).where('countries.code = ?', country).where(:id => Video.where(:is_introduction => false).pluck(:brand_id).uniq).order('LOWER(brands.name)')
        @brands = Brand.where(id: Video.joins(:video_countries, :countries).where(countries: { code: country }).where(is_introduction: false).pluck(:brand_id).uniq).order('LOWER(brands.name)')
      end

      def set_categories
        country = get_userable_country_v2(params[:email])
        @categories = VideoCategory.where(id: VideoCategoryVideo.where(video_id: Video.joins(:video_countries, :countries).where(countries: { code: country }).pluck('videos.id').uniq).pluck('video_category_videos.video_category_id').uniq).order('LOWER(name)')
      end
  end
end
