class BlogCategory < ActiveRecord::Base

  has_many :blog_blog_categories
  has_many :blogs, :through => :blog_blog_categories

  validates :name, :presence => true
  validates :url_name, :presence => true, :uniqueness => true

  def to_param
    url_name
  end

end