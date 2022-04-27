# frozen_string_literal: true

class Deal < ActiveRecord::Base
  include PgSearch::Model

  pg_search_scope :search, against: %i[title description], associated_against: {
    categories: [:name],
    brand:      :name
  }

  has_many :categoriables, as: :item, dependent: :destroy
  has_many :categories, through: :categoriables

  has_many :taggables, as: :item, dependent: :destroy
  has_many :tags, through: :taggables
  before_validation :auto_set_country
  after_save :touch_brand

  belongs_to :brand

  has_many :deal_category_deals, dependent: :destroy
  has_many :deal_categories, through: :deal_category_deals
  has_many :notifications, dependent: :destroy

  has_many :deal_countries
  has_many :countries, through: :deal_countries
  has_many :events, dependent: :destroy

  has_paper_trail

  has_attached_file :file
  validates_attachment :file, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif', 'text/plain', 'text/html', 'application/msword', 'application/vnd.ms-works', 'application/rtf', 'application/pdf', 'application/vnd.ms-powerpoint', 'application/x-compress', 'application/x-compressed', 'application/x-gzip', 'application/zip', 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'text/csv', 'text/tab-separated-values'] }
  attr_accessor :delete_file, :delete_image, :delete_hover_image

  before_validation { file.destroy if delete_file == '1' }

  has_attached_file :image, styles: { full_width: '960>', large: '460x280#', small: '300x180#' }, s3_protocol: :https, path: ':class/:attachment/:id_partition/:style/:filename'
  validates_attachment :image, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }

  before_validation { image.destroy if delete_image == '1' }

  has_attached_file :hover_image, styles: { full_width: '960>', large: '460x280#', small: '300x180#' }, s3_protocol: :https, path: ':class/:attachment/:id_partition/:style/:filename'
  validates_attachment :hover_image, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }

  before_validation { hover_image.destroy if delete_hover_image == '1' }

  validates :title, length: { maximum: 35 }, presence: true
  validates :description, length: { maximum: 400 }, presence: true
  validates :countries, presence: true

  def display_name
    "#{title} (#{countries&.size&.positive? ? countries.pluck(:name).join(', ') : 'Not assigned to any countries'})"
  end

  def is_featured_enum
    [['Yes', true], ['No', false]]
  end

  def to_param
    title.gsub(' ', '-')
  end

  # def category
  #   self.deal_category
  # end

  def image_url
    image.url(:full_width) if image.present?
  end

  def file_url
    file.url if file.present?
  end

  def brand_id
    brand&.id
  end

  def brand_name
    brand&.name
  end

  def as_json(_options = {})
    super(except: %i[brand], methods: %i[brand_id brand_name image_url file_url])
  end

  private

    def auto_set_country
      if Admin.current&.id && Admin.current&.franchisee && Admin.current&.sola_pro_country_admin.present?
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
# Table name: deals
#
#  id                       :integer          not null, primary key
#  description              :text
#  file_content_type        :string(255)
#  file_file_name           :string(255)
#  file_file_size           :integer
#  file_updated_at          :datetime
#  hover_image_content_type :string(255)
#  hover_image_file_name    :string(255)
#  hover_image_file_size    :integer
#  hover_image_updated_at   :datetime
#  image_content_type       :string(255)
#  image_file_name          :string(255)
#  image_file_size          :integer
#  image_updated_at         :datetime
#  is_featured              :boolean          default(FALSE)
#  more_info_url            :string(255)
#  title                    :string(255)
#  views                    :integer          default(0), not null
#  created_at               :datetime
#  updated_at               :datetime
#  brand_id                 :integer
#
# Indexes
#
#  index_deals_on_brand_id  (brand_id)
#  index_deals_on_views     (views DESC)
#
