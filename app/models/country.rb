class Country < ActiveRecord::Base

  has_many :blog_countries
  has_many :blogs, :through => :blog_countries

  validates :code, :uniqueness => true

end