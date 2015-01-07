class Location < ActiveRecord::Base

  after_validation :geocode
  geocoded_by :full_address

  has_attached_file :floorplan_image
  validates_attachment_content_type :floorplan_image, :content_type => /\Aimage\/.*\Z/

  validates :name, :presence => true, :uniquness => true
  validates :url_name, :presence => true, :uniqueness => true

  def full_address
    "#{address_1} #{address_2} #{city}, #{state} #{postal_code}"
  end

end