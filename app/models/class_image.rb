class ClassImage < ActiveRecord::Base
  enum kind: %w[main thumbnail]

  scope :main, -> { where(kind: 0) }
  scope :thumbnail, -> { where(kind: 1) }
  has_many :sola_classes, dependent: :restrict_with_error

  has_paper_trail

  has_attached_file :image, path: ':class/:attachment/:id_partition/:style/:filename', styles: { large: '460x280#', small: '300x180#' }, s3_protocol: :https
  validates_attachment :image, content_type: { content_type: %w[image/jpg image/jpeg image/png image/gif] }
  attr_accessor :delete_image
  before_validation { self.image.destroy if self.delete_image == '1' }
end

# == Schema Information
#
# Table name: class_images
#
#  id                 :integer          not null, primary key
#  kind               :integer
#  name               :string(255)
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  created_at         :datetime
#  updated_at         :datetime
#
