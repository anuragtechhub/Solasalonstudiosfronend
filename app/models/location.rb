class Location < ActiveRecord::Base

  has_attached_file :floorplan_image
  validates_attachment_content_type :floorplan_image, :content_type => /\Aimage\/.*\Z/

  validates :name, :presence => true
  validates :url_name, :presence => true, :uniqueness => true

end