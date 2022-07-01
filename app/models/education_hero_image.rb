# frozen_string_literal: true

class EducationHeroImage < ActiveRecord::Base
  include PgSearch::Model
  pg_search_scope :search_by_id_and_action_link, against: [:id, :action_link],
  using: {
      tsearch: {
        prefix: true
      }
    }
  has_many :education_hero_image_countries, dependent: :destroy
  has_many :countries, -> { uniq }, through: :education_hero_image_countries

  has_attached_file :image, path: ':class/:attachment/:id_partition/:style/:filename', styles: { full_width: '960>', large: '1500x1000#' }, s3_protocol: :https
  attr_accessor :delete_image

  before_validation { image.destroy if delete_image == '1' }
  validates_attachment :image, content_type: { content_type: %w[image/jpg image/jpeg image/png image/gif] }

  validates :countries, :image, :position, presence: true

  def as_json(_options = {})
    super(include: {countries: {only: [:name, :id]}}, methods: %i[image_original_url image_large_url])
  end


  def image_original_url
    image.url(:full_width)
  end

  def image_large_url
    image.url(:large)
  end
end

# == Schema Information
#
# Table name: education_hero_images
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
