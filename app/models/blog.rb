class Blog < ActiveRecord::Base

  has_many :blog_blog_categories
  has_many :blog_categories, :through => :blog_blog_categories

  validates :title, :presence => true
  validates :url_name, :presence => true, :uniqueness => true

  has_attached_file :image, :styles => { :full_width => '960#', :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  has_paper_trail

  def safe_title
    title.gsub(/&#8211;/, '-')
  end

  def to_param
    url_name
  end

end