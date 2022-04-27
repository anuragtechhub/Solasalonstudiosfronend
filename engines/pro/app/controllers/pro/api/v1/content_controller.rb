# frozen_string_literal: true

module Pro
  class Api::V1::ContentController < ApiController
    def load
      @limit = 12
      @page = 0

      render json: {
        blogs:   JSON.parse(blogs),
        brands:  JSON.parse(brands),
        classes: classes,
        deals:   JSON.parse(deals),
        tools:   JSON.parse(tools),
        videos:  JSON.parse(videos)
      }
    end

    private

      def blogs
        last_updated_blog = Blog.select(:updated_at).order(updated_at: :desc).first
        last_updated_category = BlogCategory.select(:updated_at).order(updated_at: :desc).first
        cache_key = "/api/v1/blogs?last_updated_blog=#{last_updated_blog.updated_at}&last_updated_category=#{last_updated_category.updated_at}"
        Rails.cache.fetch(cache_key) do
          @blogs = Blog.joins('INNER JOIN blog_blog_categories ON blog_blog_categories.blog_id = blogs.id').where('blogs.status = ? AND blog_blog_categories.blog_category_id != ?', 'published', 11).uniq.order('blogs.publish_date DESC')
          @categories = BlogCategory.order(name: :asc)

          @total_pages = if @blogs&.size&.positive?
                           (@blogs.size / 12) + ((@blogs.size % 12).zero? ? 0 : 1)
                         else
                           0
                         end

          @blogs = @blogs.limit(@limit).offset(@page * @limit)

          render_to_string('/api/v1/blogs/index', formats: 'json')
        end
      end

      def brands
        last_updated_brand = Brand.select(:updated_at).order(updated_at: :desc).first
        cache_key = "/api/v1/brands?last_updated=#{last_updated_brand.updated_at}"

        Rails.cache.fetch(cache_key) do
          @brands = []

          Brand.order('LOWER(brands.name)').each do |brand|
            @brands << brand if brand.content?
          end

          render_to_string('/api/v1/brands/index', formats: 'json')
        end
      end

      def classes
        regions = []
        SolaClassRegion.where(id: SolaClass.distinct.select('sola_classes.sola_class_region_id')).order('LOWER(name)').order(position: :asc).each do |region|
          region_classes = region.future_classes.order(:end_date, :start_date)

          total_pages = if region_classes&.size&.positive?
                          (region_classes.size / 3) + ((region_classes.size % 3).zero? ? 0 : 1)
                        else
                          0
                        end

          region = {
            id:          region.id,
            name:        region.name,
            page:        0,
            total_pages: total_pages,
            classes:     region_classes.limit(3)
          }

          regions << region
        end

        {
          regions: regions
        }
      end

      def deals
        last_updated_deal = Deal.select(:updated_at).order(updated_at: :desc).first
        last_updated_category = DealCategory.select(:updated_at).order(updated_at: :desc).first
        last_updated_brand = Brand.select(:updated_at).order(updated_at: :desc).first

        cache_key = "/api/v1/deals?page=#{@page}&limit=#{@limit}&last_updated_deal=#{last_updated_deal.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

        Rails.cache.fetch(cache_key) do
          @brands = Brand.where(id: Deal.distinct.select(:brand_id)).order('LOWER(name)')
          @categories = DealCategory.where(id: DealCategoryDeal.distinct.select(:deal_category_id)).order(position: :asc).order('LOWER(name)')

          @deals = Deal.order('LOWER(deals.title)')
          @total_pages = if @deals&.size&.positive?
                           (@deals.size / 12) + ((@deals.size % 12).zero? ? 0 : 1)
                         else
                           0
                         end
          @deals = @deals.limit(@limit).offset(@page * @limit)

          render_to_string('/api/v1/deals/index', formats: 'json')
        end
      end

      def tools
        last_updated_tool = Tool.select(:updated_at).order(updated_at: :desc).first
        last_updated_category = ToolCategory.select(:updated_at).order(updated_at: :desc).first
        last_updated_brand = Brand.select(:updated_at).order(updated_at: :desc).first

        cache_key = "/api/v1/tools?page=#{@page}&limit=#{@limit}&last_updated_tool=#{last_updated_tool.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

        Rails.cache.fetch(cache_key) do
          @brands = Brand.where(id: Tool.distinct.select(:brand_id)).order('LOWER(name)')
          @categories = ToolCategory.where(id: ToolCategoryTool.distinct.select(:tool_category_id)).order(position: :asc).order('LOWER(name)')

          @tools = Tool.order('LOWER(tools.title)')

          @total_pages = if @tools&.size&.positive?
                           (@tools.size / 12) + ((@tools.size % 12).zero? ? 0 : 1)
                         else
                           0
                         end

          @tools = @tools.limit(@limit).offset(@page * @limit)

          render_to_string('/api/v1/tools/index', formats: 'json')
        end
      end

      def videos
        last_updated_video = Video.select(:updated_at).order(updated_at: :desc).first
        last_updated_category = VideoCategory.select(:updated_at).order(updated_at: :desc).first
        last_updated_brand = Brand.select(:updated_at).order(updated_at: :desc).first
        last_updated_video_view = VideoView.select(:updated_at).order(updated_at: :desc).first

        cache_key = "/api/v1/videos?page=#{@page}&limit=#{@limit}&last_updated_view_view=#{last_updated_video_view.updated_at}&last_updated_video=#{last_updated_video.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

        Rails.cache.fetch(cache_key) do
          @brands = Brand.where(id: Video.where(is_introduction: false).pluck(:brand_id).uniq).order('LOWER(name)')
          @categories = VideoCategory.where(id: VideoCategoryVideo.distinct.select(:video_category_id)).order(position: :asc).order('LOWER(name)')

          @videos = Video.where(videos: { is_introduction: false }).order('videos.created_at DESC') # .order('LOWER(title)')

          @total_pages = if @videos&.size&.positive?
                           (@videos.size / 12) + ((@videos.size % 12).zero? ? 0 : 1)
                         else
                           0
                         end

          @videos = @videos.limit(@limit).offset(@page * @limit)

          render_to_string('/api/v1/videos/index', formats: 'json')
        end
      end
  end
end
