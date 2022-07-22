# frozen_string_literal: true

class Notification < ActiveRecord::Base

  include PgSearch::Model
  pg_search_scope :search_notification, against: [:title],
  associated_against: {
    brand: [:name],
    deal: [:title],
    tool: [:title],
    sola_class: [:title],
    video: [:title]
  },
  using: {
    tsearch: {
      prefix: true,
      any_word: false
    }
  }

  belongs_to :blog
  belongs_to :brand
  belongs_to :deal
  belongs_to :tool
  belongs_to :sola_class
  belongs_to :video
  belongs_to :country

  after_create :send_notification

  has_many :user_notifications, dependent: :delete_all
  has_many :notification_recipients
  has_many :stylists, through: :notification_recipients

  before_validation { self.send_at = 5.seconds.from_now if send_at.blank? }

  validates :title, presence: true, length: { maximum: 65 }
  validates :notification_text, presence: true, length: { maximum: 235 }

  def as_json(_options = {})
    super(methods: %i[ brand_name  tool_name deal_name video_name sola_class_name blog_name country_name ], include: {stylists: {only: [:name, :id]}})
  end

  def brand_name
    brand ? brand.name : ''
  end

  def tool_name
    tool ? tool.title : ''
  end 

  def deal_name
    deal ? deal.title : ''
  end 

  def video_name
    video ? video.title : ''
  end 

  def sola_class_name
    sola_class ? sola_class.title : ''
  end 


  def blog_name
    blog ? blog.title : ''
  end 

  def country_name
    country ? country.name : ''
  end 

  # TODO: refactor this
  def content_object
    blog || brand || deal || tool || sola_class || video
  end

  def country_code
    country&.code || 'US'
  end

  def send_notification
    ::Notifications::SendJob.perform_at(send_at, 'send', id, nil)
  end
end

# == Schema Information
#
# Table name: notifications
#
#  id                     :integer          not null, primary key
#  brand_id               :integer
#  deal_id                :integer
#  tool_id                :integer
#  sola_class_id          :integer
#  video_id               :integer
#  notification_text      :string(235)
#  send_push_notification :boolean
#  created_at             :datetime
#  updated_at             :datetime
#  blog_id                :integer
#  date_sent              :datetime
#  send_at                :datetime
#  title                  :string(65)
#  country_id             :integer
#
# Indexes
#
#  index_notifications_on_blog_id        (blog_id)
#  index_notifications_on_brand_id       (brand_id)
#  index_notifications_on_country_id     (country_id)
#  index_notifications_on_deal_id        (deal_id)
#  index_notifications_on_send_at        (send_at)
#  index_notifications_on_sola_class_id  (sola_class_id)
#  index_notifications_on_tool_id        (tool_id)
#  index_notifications_on_video_id       (video_id)
#
