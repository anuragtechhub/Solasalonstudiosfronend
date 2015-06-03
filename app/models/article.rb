class Article < ActiveRecord::Base

  validates :title, :presence => true
  validates :url_name, :presence => true, :uniqueness => true

  has_attached_file :image, :styles => { :full_width => '960#', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image
  before_validation { self.image.destroy if self.delete_image == '1' }

  has_paper_trail

  def to_param
    url_name
  end

  def safe_title
    EscapeUtils.escape_url(title.gsub(/&#8211;/, '-'))
  end

end