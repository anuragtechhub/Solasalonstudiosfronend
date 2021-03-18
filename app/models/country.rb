class Country < ActiveRecord::Base

  has_many :blog_countries
  has_many :blogs, :through => :blog_countries

  validates :code, :uniqueness => true

end

# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  domain     :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_countries_on_code  (code)
#
