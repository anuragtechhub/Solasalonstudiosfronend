# frozen_string_literal: true

class HomeHeroImage < ActiveRecord::Base
  has_many :home_hero_image_countries, dependent: :destroy
  has_many :countries, -> { uniq }, through: :home_hero_image_countries

  has_attached_file :image, path: ':class/:attachment/:id_partition/:style/:filename', styles: { full_width: '960>', large: '1500x1000#' }, processors: [:thumbnail], s3_protocol: :https, s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), url: ':s3_alias_url'
  attr_accessor :delete_image

  before_validation { image.destroy if delete_image == '1' }
  validates_attachment :image, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }

  validates :countries, :image, :position, presence: true

  def image_original_url
    image.url(:full_width)
  end

  def image_large_url
    image.url(:large)
  end

  def as_json(_options = {})
    super(methods: %i[image_original_url image_large_url action_link position])
  end
end

# == Schema Information
#
# Table name: home_hero_images
#
#  id                 :integer          not null, primary key
#  action_link        :string(255)
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  position           :integer
#  created_at         :datetime
#  updated_at         :datetime
#
