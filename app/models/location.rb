class Location < ActiveRecord::Base

  has_attached_file :floorplan_image
  validates_attachment_content_type :floorplan_image, :content_type => /\Aimage\/.*\Z/

end