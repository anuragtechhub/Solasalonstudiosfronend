class Article < ActiveRecord::Base

  belongs_to :location

  before_create :generate_url_name
  before_save :fix_url_name
  validates :title, :presence => true
  validates :article_url, :presence => true
  validates :location, :presence => true, :if => :franchisee?
  #validates :url_name, :presence => true, :uniqueness => true

  has_attached_file :image, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :full_width => '960#', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_attachment_presence :image
  attr_accessor :delete_image
  before_validation { self.image.destroy if self.delete_image == '1' }

  has_paper_trail

  def to_param
    url_name
  end

  def safe_title
    EscapeUtils.escape_url(title.gsub(/&#8211;/, '-'))
  end

  private

  def generate_url_name
    if self.title
      url = self.title.downcase.gsub(/[^0-9a-zA-Z]/, '_') 
      count = 1
      
      while Blog.where(:url_name => url).size > 0 do
        url = "#{url}#{count}"
        count = count + 1
      end

      self.url_name = url
    end
  end

  def fix_url_name
    self.url_name = self.url_name.gsub(/[^0-9a-zA-Z]/, '_') if self.url_name.present?
  end

  def franchisee?
    if Thread.current[:current_admin] 
      Thread.current[:current_admin].franchisee
    end
  end

end