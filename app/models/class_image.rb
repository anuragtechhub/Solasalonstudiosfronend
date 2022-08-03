# frozen_string_literal: true

class ClassImage < ActiveRecord::Base
  include PgSearch::Model

  pg_search_scope :search_by_name, against: [:name],
    using: {
      tsearch: {
        prefix: true
      }
    }

  has_many :sola_classes, dependent: :restrict_with_error

  has_paper_trail

  has_attached_file :image, path: ':class/:attachment/:id_partition/:style/:filename', styles: { full_width: '960>', large: '460x280#', small: '300x180#' }, s3_protocol: :https
  validates_attachment :image, content_type: { content_type: %w[image/jpg image/jpeg image/png image/gif] }
  attr_accessor :delete_image, :delete_thumbnail

  before_validation { image.destroy if delete_image == '1' }

  has_attached_file :thumbnail, path: ':class/:attachment/:id_partition/:style/:filename', styles: { full_width: '960>', large: '460x280#', small: '300x180#' }, s3_protocol: :https
  validates_attachment :thumbnail, content_type: { content_type: %w[image/jpg image/jpeg image/png image/gif] }

  before_validation { thumbnail.destroy if delete_thumbnail == '1' }

  def as_json(_options = {})
    super(except: %i[ image_content_type image_file_name image_file_size image_updated_at  thumbnail_file_name thumbnail_content_type thumbnail_file_size thumbnail_updated_at], methods: %i[image_original_url image_large_url thumbnail_original_url thumbnail_large_url])
  end

  def image_original_url
    image&.url(:full_width) if image.present?
  end

  def image_large_url
    image&.url(:large) if image.present?
  end

  def thumbnail_original_url
    thumbnail&.url(:full_width) if thumbnail.present?
  end

  def thumbnail_large_url
    thumbnail&.url(:large) if thumbnail.present?
  end
end

# == Schema Information
#
# Table name: class_images
#
#  id                     :integer          not null, primary key
#  image_content_type     :string(255)
#  image_file_name        :string(255)
#  image_file_size        :integer
#  image_updated_at       :datetime
#  name                   :string(255)
#  thumbnail_content_type :string(255)
#  thumbnail_file_name    :string(255)
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#
