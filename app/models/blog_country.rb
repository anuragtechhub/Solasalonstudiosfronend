class BlogCountry < ActiveRecord::Base
  belongs_to :blog
  belongs_to :country
end
