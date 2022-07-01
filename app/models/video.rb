# frozen_string_literal: true

class Video < ActiveRecord::Base
  include PgSearch::Model
  pg_search_scope :search_by_title, against: [:title],
  associated_against: {
    brand: [:name],
    categories: [:name]
  },
  using: {
    tsearch: {
      prefix: true,
      any_word: true
    }
  }

  multisearchable against: [:stripped_title]

  scope :webinars, lambda {
    where(webinar: true)
  }

  scope :not_webinars, lambda {
    where.not(webinar: true)
  }

  has_many :categoriables, as: :item, dependent: :destroy
  has_many :categories, through: :categoriables

  before_validation :auto_set_country
  after_save :touch_brand

  belongs_to :brand
  belongs_to :tool

  has_many :video_category_videos, dependent: :destroy
  has_many :video_categories, through: :video_category_videos
  has_many :notifications, dependent: :destroy
  has_many :tags_videos

  has_many :taggables, as: :item, dependent: :destroy
  has_many :tags, through: :taggables

  has_many :video_views, dependent: :destroy
  has_many :watch_laters, dependent: :destroy
  has_many :saved_items, dependent: :destroy, inverse_of: :video

  has_many :video_countries
  has_many :countries, through: :video_countries
  has_many :events, dependent: :destroy

  has_paper_trail

  validates :title, length: { maximum: 50 }, presence: true
  validates :countries, :youtube_url, :brand, presence: true

  def is_featured_enum
    [['Yes', true], ['No', false]]
  end

  def is_introduction_enum
    [['Yes', true], ['No', false]]
  end

  def youtube_video_id
    (Rack::Utils.parse_query URI(youtube_url).query)['v']
  rescue StandardError => e
    NewRelic::Agent.notice_error(e)
    Rollbar.error(e)
    Rack::Utils.parse_nested_query(youtube_url).first.second
  end

  def image_url
    "//img.youtube.com/vi/#{youtube_video_id}/maxresdefault.jpg" # hqdefault
  end

  # def category
  #   self.video_category
  # end

  def stripped_title
    title&.strip
  end

  def brand_name
    brand&.name
  end

  def brand_id
    brand&.id
  end

  def tool_file_url
    tool.file.url if tool&.file && tool.file.present?
  end

  def tool_title
    tool&.title
  end

  def tool_id
    tool&.id
  end

  def view_count
    VideoView.where(video_id: id).size
  end

  def watch_later_for_user(user)
    return false unless user

    WatchLater.where(userable_id: user.id, userable_type: user.class.name, video_id: id).size.positive?
  end

  def as_json(_options = {})
    super(except: [:brand], methods: %i[brand_id brand_name image_url youtube_video_id tool_file_url tool_title tool_id view_count ], include: %i[categories])
  end
  
  private

    def auto_set_country
      if Admin&.current && Admin.current.id && Admin.current.franchisee && Admin.current.sola_pro_country_admin.present?
        country = Country.where(code: Admin.current.sola_pro_country_admin)
        if country && countries.none? { |c| c.code == Admin.current.sola_pro_country_admin }
          countries << country
        end
      end
    end

    def touch_brand
      brand&.touch
    end
end

# == Schema Information
#
# Table name: videos
#
#  id              :integer          not null, primary key
#  description     :text
#  duration        :string(255)
#  is_featured     :boolean          default(FALSE)
#  is_introduction :boolean          default(FALSE)
#  link_text       :string(255)
#  link_url        :string(255)
#  title           :string(255)
#  views           :integer          default(0), not null
#  webinar         :boolean          default(FALSE)
#  youtube_url     :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  brand_id        :integer
#  tool_id         :integer
#
# Indexes
#
#  index_videos_on_brand_id  (brand_id)
#  index_videos_on_tool_id   (tool_id)
#  index_videos_on_views     (views DESC)
#
