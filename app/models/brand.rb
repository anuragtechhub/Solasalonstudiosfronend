class Brand < ActiveRecord::Base

  # before_validation :auto_set_country

  has_many :deals, :dependent => :destroy
  has_many :videos, :dependent => :destroy
  #has_many :sola_classes
  has_many :tools, :dependent => :destroy
  # has_many :brand_links, -> { order 'position' }, :dependent => :destroy
  # has_many :product_informations, :dependent => :destroy
  has_and_belongs_to_many :sola_classes
  # has_many :notifications, :dependent => :destroy
  #
  # has_many :brand_countries
  # has_many :countries, :through => :brand_countries
  #
  # has_many :events, :dependent => :destroy

  has_paper_trail

  has_attached_file :image, :path => ":class/:attachment/:id_partition/:style/:filename", :styles => { :full_width => '960>', :large => "460x280#", :small => "300x180#" }, :s3_protocol => :https
  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  attr_accessor :delete_image
  before_validation { self.image.destroy if self.delete_image == '1' }

  # has_attached_file :hover_image, :styles => { :large => "460x280#", :small => "300x180#" }, :s3_protocol => :https
  # validates_attachment :hover_image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  # attr_accessor :delete_hover_image
  # before_validation { self.hover_image.destroy if self.delete_hover_image == '1' }

  #has_attached_file :white_image, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'decutywx15n1m.cloudfront.net', :styles => { :large => "460x280#", :small => "300x180#" }, :s3_protocol => :https
  #validates_attachment :white_image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  #attr_accessor :delete_white_image
  #before_validation { self.white_image.destroy if self.delete_white_image == '1' }

  validates :name, :length => { :maximum => 50 }, :uniqueness => true, :presence => true
  #validates :countries, :presence => true

  def display_name
    "#{name} (#{countries && countries.size > 0 ? countries.pluck(:name).join(', ') : 'Not assigned to any countries'})"
  end

  def to_param
    name.gsub(' ', '-')
  end

  def image_url
    image.url(:full_width) if image.present?
  end

  def classes
    sola_classes
  end

  def links
    brand_links
  end

  def introduction_video
    videos.where('is_introduction = ?', true).first
  end

  def upcoming_classes
    sola_classes.where('end_date >= ?', Date.today).order(:title => :asc, :end_date => :asc, :start_date => :asc) if sola_classes
  end

  def brand_videos
    videos.joins('LEFT OUTER JOIN video_category_videos ON video_category_videos.video_id = videos.id')
      .where("is_introduction != TRUE")
      .where("video_category_videos.video_category_id != 7")
      .order(:title => :asc)
      .uniq
  end

  def past_webinar_videos
    videos.joins('LEFT OUTER JOIN video_category_videos ON video_category_videos.video_id = videos.id')
      .where("is_introduction != TRUE")
      .where("video_category_videos.video_category_id = 7")
      .order(:title => :asc)
      .uniq
  end

  def title
    name
  end

  def content?
    (deals && deals.length > 0) || (links && links.length > 0) || (tools && tools.length > 0) || (videos && videos.length > 0) || (upcoming_classes && upcoming_classes.length > 0)
  end

  def only_deals
    classes && classes.size == 0 && links && links.size == 0 && tools && tools.size == 0 && videos && videos.size == 0
  end

  def as_json(options={})
    super(:only => [:name, :website_url, :introduction_video_heading_title, :events_and_classes_heading_title], :methods => [:classes, :deals, :image_url, :links, :tools, :videos, :title])
  end

  # country-filtered content

  def brand_videos_by_country(country='US')
    videos.joins(:video_countries, :countries).where('countries.code = ?', country)
      .joins('LEFT OUTER JOIN video_category_videos ON video_category_videos.video_id = videos.id')
      .where("is_introduction != TRUE")
      .where("video_category_videos.video_category_id != 7")
      .order(:title => :asc)
      .uniq
  end

  def deals_by_country(country='US')
    deals.joins(:deal_countries, :countries).where('countries.code = ?', country).uniq
  end

  def introduction_video_by_country(country='US')
    videos.joins(:video_countries, :countries).where('countries.code = ?', country).where('is_introduction = ?', true).first
  end

  def past_webinar_videos_by_country(country='US')
    videos.joins(:video_countries, :countries).where('countries.code = ?', country)
      .joins('LEFT OUTER JOIN video_category_videos ON video_category_videos.video_id = videos.id')
      .where("is_introduction != TRUE")
      .where("video_category_videos.video_category_id = 7")
      .order(:title => :asc)
      .uniq
  end

  def tools_by_country(country='US')
    tools.joins(:tool_countries, :countries).where('countries.code = ?', country).uniq
  end

  # def upcoming_classes_by_country(country='US')
  #   classes = upcoming_classes
  #
  #   regions = SolaClassRegion.joins(:sola_class_region_countries, :countries).where('countries.code = ?', country)
  #
  #   return classes.uniq if regions.size == 0
  #
  #   classes.where(:sola_class_region_id => regions.pluck(:id)).uniq
  # end

  private

  # def auto_set_country
  #   if Admin && Admin.current && Admin.current.id && Admin.current.franchisee && Admin.current.sola_pro_country_admin.present?
  #     country = Country.where('code = ?', Admin.current.sola_pro_country_admin)
  #     if country
  #       self.countries << country unless self.countries.any?{|c| c.code == Admin.current.sola_pro_country_admin}
  #     end
  #   end
  # end

end

# == Schema Information
#
# Table name: brands
#
#  id                               :integer          not null, primary key
#  events_and_classes_heading_title :string(255)      default("Classes")
#  image_content_type               :string(255)
#  image_file_name                  :string(255)
#  image_file_size                  :integer
#  image_updated_at                 :datetime
#  introduction_video_heading_title :string(255)      default("Introduction")
#  name                             :string(255)
#  views                            :integer          default(0), not null
#  website_url                      :string(255)
#  white_image_content_type         :string(255)
#  white_image_file_name            :string(255)
#  white_image_file_size            :integer
#  white_image_updated_at           :datetime
#  created_at                       :datetime
#  updated_at                       :datetime
#
# Indexes
#
#  index_brands_on_views  (views DESC)
#
