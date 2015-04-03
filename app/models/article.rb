class Article < ActiveRecord::Base

  validates :title, :presence => true
  validates :url_title, :presence => true, :uniqueness => true

  has_attached_file :image, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  has_paper_trail

end