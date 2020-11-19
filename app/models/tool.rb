class Tool < ActiveRecord::Base

  has_many :categoriables, as: :item, dependent: :destroy
  has_many :categories, through: :categoriables

  has_many :taggables, as: :item, dependent: :destroy
  has_many :tags, through: :taggables

  after_save :touch_brand
  # before_validation :auto_set_country
  #
  belongs_to :brand
  has_many :videos
  #
  has_many :tool_category_tools, :dependent => :destroy
  has_many :tool_categories, :through => :tool_category_tools
  # has_many :notifications, :dependent => :destroy
  #
  # has_many :tool_countries
  # has_many :countries, :through => :tool_countries
  # has_many :events, :dependent => :destroy
  #
  has_paper_trail

  has_attached_file :file, :path => ":class/:attachment/:id_partition/:style/:filename"
  attr_accessor :delete_file
  before_validation { self.file.destroy if self.delete_file == '1' }

  has_attached_file :image, :path => ":class/:attachment/:id_partition/:style/:filename", :styles => { :large => "460x280#", :small => "300x180#" }, processors: [:thumbnail, :compression], :s3_protocol => :https
  attr_accessor :delete_image
  before_validation { self.image.destroy if self.delete_image == '1' }

  validates_attachment :file, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "text/plain", "text/html", "application/msword", "application/vnd.ms-works", "application/rtf", "application/pdf", "application/vnd.ms-powerpoint", "application/x-compress", "application/x-compressed", "application/x-gzip", "application/zip", "application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "text/csv", "text/tab-separated-values"] }
  validates :title, :length => { :maximum => 35 }, :presence => true
  validates :description, :length => { :maximum => 400 }, :presence => true
  #validates :countries, :presence => true
  #
  # def to_param
  #   title.gsub(' ', '-')
  # end
  #
  # def is_featured_enum
  #   [['Yes', true], ['No', false]]
  # end

  def image_url
    image.url(:large) if image.present?
  end

  def file_url
    file.url if file
  end

  def brand_name
    brand.name if brand
  end

  def brand_id
    brand.id if brand
  end

  # def as_json(options={})
  #   super(:except => [:brand], :methods => [:brand_id, :brand_name, :image_url, :file_url, :videos])
  # end
  #
  private
  #
  # def auto_set_country
  #   if Admin && Admin.current && Admin.current.id && Admin.current.franchisee && Admin.current.sola_pro_country_admin.present?
  #     country = Country.where('code = ?', Admin.current.sola_pro_country_admin)
  #     if country
  #       self.countries << country unless self.countries.any?{|c| c.code == Admin.current.sola_pro_country_admin}
  #     end
  #   end
  # end
  #
  def touch_brand
    self.brand.touch if self.brand
  end

end

# == Schema Information
#
# Table name: tools
#
#  id                 :integer          not null, primary key
#  brand_id           :integer
#  title              :string(255)
#  description        :text
#  is_featured        :boolean          default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  file_file_name     :string(255)
#  file_content_type  :string(255)
#  file_file_size     :integer
#  file_updated_at    :datetime
#  link_url           :string(255)
#  youtube_url        :string(255)
#
# Indexes
#
#  index_tools_on_brand_id  (brand_id)
#
