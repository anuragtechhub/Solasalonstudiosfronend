# frozen_string_literal: true

class ProductInformation < ActiveRecord::Base
  after_save :touch_brand

  belongs_to :brand

  has_paper_trail

  has_attached_file :file, path: ':class/:attachment/:id_partition/:style/:filename', s3_protocol: :https, s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil)
  attr_accessor :delete_file, :delete_image

  before_validation { file.destroy if delete_file == '1' }

  has_attached_file :image, path: ':class/:attachment/:id_partition/:style/:filename', styles: { full_width: '960>', large: '460x280#', small: '300x180#' }, s3_protocol: :https, s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), url: ':s3_alias_url'

  before_validation { image.destroy if delete_image == '1' }

  validates_attachment :file, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif', 'text/plain', 'text/html', 'application/msword', 'application/vnd.ms-works', 'application/rtf', 'application/pdf', 'application/vnd.ms-powerpoint', 'application/x-compress', 'application/x-compressed', 'application/x-gzip', 'application/zip', 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'text/csv', 'text/tab-separated-values'] }
  validates :title, length: { maximum: 35 }, presence: true

  def to_param
    title.gsub(' ', '-')
  end

  def image_url
    image.url(:full_width) if image.present?
  end

  def file_url
    file&.url
  end

  def brand_name
    brand&.name
  end

  def as_json(_options = {})
    super(except: %i[brand], methods: %i[brand_name image_url file_url])
  end

  private

    def touch_brand
      brand&.touch
    end
end

# == Schema Information
#
# Table name: product_informations
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  description        :text
#  link_url           :string(255)
#  brand_id           :integer
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
#
# Indexes
#
#  index_product_informations_on_brand_id  (brand_id)
#
