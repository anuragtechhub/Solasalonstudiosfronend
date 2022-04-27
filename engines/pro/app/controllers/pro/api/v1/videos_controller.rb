# frozen_string_literal: true

module Pro
  class Api::V1::VideosController < ApiController
    # before_action :set_categories, :set_brands

    def index
      country = get_userable_country(params[:email])

      @limit = 12
      @page = params[:page].present? ? params[:page].to_i : 0

      last_updated_video = Video.select(:updated_at).order(updated_at: :desc).first
      last_updated_category = VideoCategory.select(:updated_at).order(updated_at: :desc).first
      last_updated_brand = Brand.select(:updated_at).order(updated_at: :desc).first
      last_updated_video_view = VideoView.select(:updated_at).order(updated_at: :desc).first

      cache_key = "/api/v1/videos?country=#{country}&page=#{@page}&limit=#{@limit}&last_updated_view_view=#{last_updated_video_view.updated_at}&last_updated_video=#{last_updated_video.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

      json = Rails.cache.fetch(cache_key) do
        @brands = set_brands
        @categories = set_categories

        @videos = Video.joins(:video_countries, :countries).where(countries: { code: country }).where(videos: { is_introduction: false }).order('videos.created_at DESC') # .order('LOWER(title)')

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

    def load_more
      country = get_userable_country(params[:email])

      @limit = 12
      @page = params[:page].present? ? params[:page].to_i : 0

      last_updated_video = Video.select(:updated_at).order(updated_at: :desc).first
      last_updated_category = VideoCategory.select(:updated_at).order(updated_at: :desc).first
      last_updated_brand = Brand.select(:updated_at).order(updated_at: :desc).first
      last_updated_video_view = VideoView.select(:updated_at).order(updated_at: :desc).first

      cache_key = "/api/v1/videos_load_more?country=#{country}&category_name=#{params[:category_name]}&last_updated_view_view=#{last_updated_video_view.updated_at}&brand_name=#{params[:brand_name]}&page=#{@page}&limit=#{@limit}&last_updated_video=#{last_updated_video.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

      json = Rails.cache.fetch(cache_key) do
        @brands = set_brands
        @categories = set_categories

        if params[:category_name]
          @category = VideoCategory.find_by(name: params[:category_name].gsub('-', ' '))
          @videos = @category.videos.where(is_introduction: false).order('created_at DESC') # .order('LOWER(title)')
        elsif params[:brand_name]
          @brand = Brand.find_by(name: params[:brand_name].gsub('-', ' '))
          @videos = Video.joins(:video_countries, :countries).where(countries: { code: country }).where(videos: { is_introduction: false }).where(videos: { brand_id: @brand.id }).order('videos.created_at DESC') # .order('LOWER(title)')
        else
          @videos = Video.joins(:video_countries, :countries).where(countries: { code: country }).where(videos: { is_introduction: false }).order('videos.created_at DESC') # .order('LOWER(title)')
        end

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
      @videos = VideoView.where(id: VideoView.select('DISTINCT ON (video_id) *').where(userable_id: userable.id, userable_type: userable.class.name).map(&:id)).order(:created_at)

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
      @videos = WatchLater.where(userable_id: userable.id, userable_type: userable.class.name).order(:created_at)

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

        country = get_userable_country(params[:email])
        videos = []
        query_param = "%#{query.downcase.gsub(/\s/, '%')}%"

        Video.joins(:brand).where('LOWER(videos.title) LIKE ? OR LOWER(brands.name) LIKE ?', query_param, query_param).each do |video|
          videos << video unless videos.include?(video)
        end

        VideoCategory.where('LOWER(name) LIKE ?', query_param).each do |category|
          category.videos.each do |video|
            videos << video unless videos.include?(video)
          end
        end

        videos.sort { |a, b| a.created_at <=> b.created_at }

        video_tags = Tag.where('LOWER(name) = ?', query.downcase.gsub(/\s/, '%')).each do |tag|
          tag.videos.each do |video|
            videos.unshift(video) unless videos.include?(video)
          end
        end

        videos.uniq # .sort{|a, b| a.created_at <=> b.created_at }
      end

      def set_brands
        country = get_userable_country(params[:email])
        @brands = Brand.where(id: Video.where(is_introduction: false).pluck(:brand_id).uniq).order('LOWER(name)')
      end

      def set_categories
        country = get_userable_country(params[:email])
        @categories = VideoCategory.where(id: VideoCategoryVideo.distinct.select(:video_category_id)).order(position: :asc).order('LOWER(name)')
      end
  end
end
