# frozen_string_literal: true

class Tool < ActiveRecord::Base
  include PgSearch::Model

  pg_search_scope :search, against: :title, associated_against: {
    categories: [:name],
    brand:      :name
  }
  multisearchable against: [:stripped_title]

  has_many :categoriables, as: :item, dependent: :destroy
  has_many :categories, through: :categoriables

  has_many :taggables, as: :item, dependent: :destroy
  has_many :tags, through: :taggables

  before_validation :auto_set_country
  after_save :touch_brand

  belongs_to :brand
  has_many :videos

  has_many :tool_category_tools, dependent: :destroy
  has_many :tool_categories, through: :tool_category_tools
  has_many :notifications, dependent: :destroy

  has_many :tool_countries
  has_many :countries, through: :tool_countries
  has_many :events, dependent: :destroy

  has_paper_trail

  has_attached_file :file, path: ':class/:attachment/:id_partition/:style/:filename',  s3_protocol: :https
  attr_accessor :delete_file, :delete_image

  before_validation { file.destroy if delete_file == '1' }

  has_attached_file :image, path: ':class/:attachment/:id_partition/:style/:filename', styles: { full_width: '960>', large: '460x280#', small: '300x180#' }, s3_protocol: :https

  before_validation { image.destroy if delete_image == '1' }

  validates_attachment :file, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif', 'text/plain', 'text/html', 'application/msword', 'application/vnd.ms-works', 'application/rtf', 'application/pdf', 'application/vnd.ms-powerpoint', 'application/x-compress', 'application/x-compressed', 'application/x-gzip', 'application/zip', 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'text/csv', 'text/tab-separated-values'] }, s3_protocol: :https
  validates :title, length: { maximum: 35 }, presence: true
  # validates :description, :length => { :maximum => 400 }, :presence => true
  validates :countries, presence: true

  scope :with_file, -> { where.not(file_file_name: nil) }

  def as_json(_options = {})
    super(except: %i[brand image_content_type image_file_name image_file_size image_updated_at  file_file_name file_content_type file_file_size file_updated_at], methods: %i[brand_id brand_name image_url file_url category tag],
      include: {videos: {only: [:title, :id]}})
  end


  def to_param
    title.gsub(' ', '-')
  end

  def is_featured_enum
    [['Yes', true], ['No', false]]
  end

  def image_url
    image.url(:full_width) if image.present?
  end

  def stripped_title
    title&.strip
  end

  def file_url
    file&.url
  end

  def brand_name
    brand&.name
  end

  def brand_id
    brand&.id
  end

  def category
    self.categories&.map{ | a| {id: a.id, name: a.name} }
  end 

  def tag
    self.tags&.map{ | a| {id: a.id, name: a.name} }
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
# Table name: tools
#
#  id                 :integer          not null, primary key
#  description        :text
#  file_content_type  :string(255)
#  file_file_name     :string(255)
#  file_file_size     :integer
#  file_updated_at    :datetime
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  is_featured        :boolean          default(FALSE)
#  link_url           :string(255)
#  title              :string(255)
#  views              :integer          default(0), not null
#  youtube_url        :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  brand_id           :integer
#
# Indexes
#
#  index_tools_on_brand_id  (brand_id)
#  index_tools_on_views     (views DESC)
#
