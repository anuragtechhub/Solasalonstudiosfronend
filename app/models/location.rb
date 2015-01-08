class Location < ActiveRecord::Base

  after_validation :geocode
  geocoded_by :full_address

  has_attached_file :floorplan_image
  validates_attachment_content_type :floorplan_image, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_1
  validates_attachment_content_type :image_1, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_2
  validates_attachment_content_type :image_2, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_3
  validates_attachment_content_type :image_3, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_4
  validates_attachment_content_type :image_4, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_5
  validates_attachment_content_type :image_5, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_6
  validates_attachment_content_type :image_6, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_7
  validates_attachment_content_type :image_7, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_8
  validates_attachment_content_type :image_8, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_9
  validates_attachment_content_type :image_9, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_10
  validates_attachment_content_type :image_10, :content_type => /\Aimage\/.*\Z/              

  validates :name, :presence => true, :uniqueness => true
  validates :url_name, :presence => true, :uniqueness => true

  def full_address
    "#{address_1} #{address_2} #{city}, #{state} #{postal_code}"
  end

end