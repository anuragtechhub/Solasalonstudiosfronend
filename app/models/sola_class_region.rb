# frozen_string_literal: true

class SolaClassRegion < ActiveRecord::Base
  has_many :sola_classes # , -> { order 'create' }

  has_many :sola_class_region_countries, dependent: :destroy
  has_many :countries, -> { uniq }, through: :sola_class_region_countries

  has_attached_file :image, path: ':class/:attachment/:id_partition/:style/:filename', styles: { full_width: '960>', large: '166x105#' }, s3_protocol: :https, s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), url: ':s3_alias_url'
  attr_accessor :delete_image

  before_validation { image.destroy if delete_image == '1' }
  validates_attachment :image, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }

  validates :name, :countries, :position, presence: true # , :uniqueness => true, :length => { :maximum => 30 }

  def to_param
    name.gsub(' ', '-')
  end

  def future_classes
    if name && name == 'Past Webinars'
      sola_classes.where('end_date <= ?', Date.today).order(created_at: :desc).order(:title, :id)
    else
      sola_classes.where('end_date >= ?', Date.today).order(:end_date, :start_date, :title, :id)
    end
  end

  def image_original_url
    image_file_name.present? ? image.url(:full_width) : nil
  end

  def image_large_url
    image_file_name.present? ? image.url(:large) : nil
  end

  def as_json(_options = {})
    super(methods: %i[image_original_url image_large_url]) # , :name, :future_classes, :position, :country])
  end
end

# == Schema Information
#
# Table name: sola_class_regions
#
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  name               :string(255)
#  position           :integer
#  created_at         :datetime
#  updated_at         :datetime
#
