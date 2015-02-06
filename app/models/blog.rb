class Blog < ActiveRecord::Base

  has_attached_file :image, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

end