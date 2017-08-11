class BlogCategory < ActiveRecord::Base

  has_paper_trail
  
  before_save :fix_url_name
  
  has_many :blog_blog_categories
  has_many :blogs, :through => :blog_blog_categories

  validates :name, :presence => true
  validates :url_name, :presence => true, :uniqueness => true

  def to_param
    url_name
  end

  def fix_url_name
    if self.url_name.present?
      self.url_name = self.url_name.gsub(/[^0-9a-zA-Z]/, '_')
      self.url_name = self.url_name.gsub('___', '_')
      self.url_name = self.url_name.gsub('_-_', '_')
      self.url_name = self.url_name.split('_')
      self.url_name = self.url_name.map{ |u| u.downcase }
      self.url_name = self.url_name.join('-')
    end
  end

end