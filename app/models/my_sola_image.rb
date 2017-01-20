class MySolaImage < ActiveRecord::Base

  before_save :set_approved_at, :if => :was_just_approved

  has_attached_file :image, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :instagram => '1080x1080#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image
  before_validation { self.image.destroy if self.delete_image == '1' }

  def approved_enum
    [['Yes', true], ['No', false]]
  end

  private

  def set_approved_at
    approved_at = DateTime.now
  end

  def was_just_approved
    approved == true && approved_was == false
  end

end