# frozen_string_literal: true

module Pro
  class Api::V2::ContentController < ApiController
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
        country = get_userable_country_v2(params[:email])
        last_updated_blog = Blog.select(:updated_at).order(updated_at: :desc).first
        last_updated_category = BlogCategory.select(:updated_at).order(updated_at: :desc).first
        cache_key = "/api/v2/blogs?country=#{country}&last_updated_blog=#{last_updated_blog ? last_updated_blog.updated_at : nil}&last_updated_category=#{last_updated_category ? last_updated_category.updated_at : nil}"

        Rails.cache.fetch(cache_key) do
          @blogs = Blog.joins('INNER JOIN blog_blog_categories ON blog_blog_categories.blog_id = blogs.id').joins(:blog_countries, :countries).where(countries: { code: country }).where('blogs.status = ? AND blog_blog_categories.blog_category_id != ?', 'published', 11).uniq.order('blogs.publish_date DESC')
          @categories = BlogCategory.where(id: BlogBlogCategory.where(blog_id: Blog.joins(:blog_countries, :countries).where(countries: { code: country }).pluck('blogs.id').uniq).pluck('blog_blog_categories.blog_category_id').uniq).order('LOWER(name)') # BlogCategory.order(:name => :asc)

          @total_pages = if @blogs&.size&.positive?
                           (@blogs.size / 12) + ((@blogs.size % 12).zero? ? 0 : 1)
                         else
                           0
                         end

          @blogs = @blogs.limit(@limit).offset(@page * @limit)

          render_to_string('/api/v2/blogs/index', formats: 'json')
        end
      end

      def brands
        country = get_userable_country_v2(params[:email])
        @country = country
        last_updated_brand = Brand.select(:updated_at).order(updated_at: :desc).first
        cache_key = "/api/v2/brands?country=#{country}&last_updated=#{last_updated_brand.updated_at}"

        Rails.cache.fetch(cache_key) do
          @brands = []

          Brand.joins(:brand_countries, :countries).where(countries: { code: country }).order('LOWER(brands.name)').group('brands.id').each do |brand|
            @brands << brand if brand.content?
          end

          render_to_string('/api/v2/brands/index', formats: 'json')
        end
      end

      def classes
        country = get_userable_country_v2(params[:email])
        regions = []
        # SolaClassRegion.joins(:sola_class_region_countries, :countries).where('countries.code = ?', country).where(:id => SolaClass.joins(:sola_class_countries, :countries).where('countries.code = ?', country).pluck('sola_classes.sola_class_region_id').uniq).order('LOWER(sola_class_regions.name)').order(:position => :asc).each do |region|
        SolaClassRegion.joins(:sola_class_region_countries, :countries).where(countries: { code: country }).order('sola_class_regions.position ASC').uniq.each do |region|
          p "region=#{region.name}"
          region_classes = region.future_classes.order(:end_date, :start_date)

          total_pages = if region_classes&.size&.positive?
                          (region_classes.size / 3) + ((region_classes.size % 3).zero? ? 0 : 1)
                        else
                          0
                        end

          region = {
            id:                 region.id,
            name:               region.name,
            image_original_url: region.image_original_url,
            image_large_url:    region.image_large_url,
            position:           region.position,
            page:               0,
            total_pages:        total_pages,
            classes:            region_classes.limit(3)
          }

          regions << region
        end

        {
          regions: regions.sort_by { |r| r[:position] }
        }
      end

      def deals
        country = get_userable_country_v2(params[:email])
        last_updated_deal = Deal.select(:updated_at).order(updated_at: :desc).first
        last_updated_category = DealCategory.select(:updated_at).order(updated_at: :desc).first
        last_updated_brand = Brand.select(:updated_at).order(updated_at: :desc).first

        cache_key = "/api/v2/deals?country=#{country}&page=#{@page}&limit=#{@limit}&last_updated_deal=#{last_updated_deal.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

        Rails.cache.fetch(cache_key) do
          # @brands = Brand.joins(:brand_countries, :countries).where('countries.code = ?', country).where(:id => Deal.pluck(:brand_id).uniq).order('LOWER(brands.name)')
          @brands = Brand.where(id: Deal.joins(:deal_countries, :countries).where(countries: { code: country }).where(countries: { code: country }).pluck(:brand_id).uniq).order('LOWER(brands.name)')
          @categories = DealCategory.where(id: DealCategoryDeal.where(deal_id: Deal.joins(:deal_countries, :countries).where(countries: { code: country }).pluck('deals.id').uniq).pluck('deal_category_deals.deal_category_id').uniq).order('LOWER(name)')

          @deals = Deal.joins(:deal_countries, :countries).where(countries: { code: country }).order('LOWER(deals.title)').group('deals.id')

          p "@deals=#{@deals.inspect}"

          @total_pages = if @deals&.size&.positive?
                           (@deals.size / 12) + ((@deals.size % 12).zero? ? 0 : 1)
                         else
                           0
                         end
          @deals = @deals.limit(@limit).offset(@page * @limit)

          render_to_string('/api/v2/deals/index', formats: 'json')
        end
      end

      def tools
        country = get_userable_country_v2(params[:email])
        last_updated_tool = Tool.select(:updated_at).order(updated_at: :desc).first
        last_updated_category = ToolCategory.select(:updated_at).order(updated_at: :desc).first
        last_updated_brand = Brand.select(:updated_at).order(updated_at: :desc).first

        cache_key = "/api/v2/tools?country=#{country}&page=#{@page}&limit=#{@limit}&last_updated_tool=#{last_updated_tool.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

        Rails.cache.fetch(cache_key) do
          @brands = Brand.where(id: Tool.joins(:tool_countries, :countries).where(countries: { code: country }).where(countries: { code: country }).pluck(:brand_id).uniq).order('LOWER(brands.name)')
          @categories = ToolCategory.where(id: ToolCategoryTool.where(tool_id: Tool.joins(:tool_countries, :countries).where(countries: { code: country }).pluck('tools.id').uniq).pluck('tool_category_tools.tool_category_id').uniq).order('LOWER(name)')

          @tools = Tool.joins(:tool_countries, :countries).where(countries: { code: country }).order(created_at: :desc).group('tools.id')

          p "@tools=#{@tools.inspect}"

          @total_pages = if @tools&.size&.positive?
                           (@tools.size / 12) + ((@tools.size % 12).zero? ? 0 : 1)
                         else
                           0
                         end

          @tools = @tools.limit(@limit).offset(@page * @limit)

          render_to_string('/api/v2/tools/index', formats: 'json')
        end
      end

      def videos
        country = get_userable_country_v2(params[:email])
        last_updated_video = Video.select(:updated_at).order(updated_at: :desc).first
        last_updated_category = VideoCategory.select(:updated_at).order(updated_at: :desc).first
        last_updated_brand = Brand.select(:updated_at).order(updated_at: :desc).first
        last_updated_video_view = VideoView.select(:updated_at).order(updated_at: :desc).first

        cache_key = "/api/v2/videos?country=#{country}&page=#{@page}&limit=#{@limit}&last_updated_view_view=#{last_updated_video_view.updated_at}&last_updated_video=#{last_updated_video.updated_at}&last_updated_category=#{last_updated_category.updated_at}&last_updated_brand=#{last_updated_brand.updated_at}"

        Rails.cache.fetch(cache_key) do
          @brands = Brand.where(id: Video.joins(:video_countries, :countries).where(countries: { code: country }).where(is_introduction: false).pluck(:brand_id).uniq).group('brands.id').order('LOWER(brands.name)') # Brand.where(:id => Video.pluck(:brand_id).uniq).order('LOWER(brands.name)')
          @categories = VideoCategory.where(id: VideoCategoryVideo.where(video_id: Video.joins(:video_countries, :countries).where(countries: { code: country }).pluck('videos.id').uniq).pluck('video_category_videos.video_category_id').uniq).order('LOWER(name)')

          @videos = Video.joins(:video_countries, :countries).where(countries: { code: country }).where(videos: { is_introduction: false }).order('videos.created_at DESC').group('videos.id') # .order('LOWER(title)')

          p "@videos=#{@videos.inspect}"

          @total_pages = if @videos&.size&.positive?
                           (@videos.size / 12) + ((@videos.size % 12).zero? ? 0 : 1)
                         else
                           0
                         end

          @videos = @videos.limit(@limit).offset(@page * @limit)

          render_to_string('/api/v2/videos/index', formats: 'json')
        end
      end
  end
end
