# frozen_string_literal: true

class BlogCountry < ActiveRecord::Base
  belongs_to :blog
  belongs_to :country
end

# == Schema Information
#
# Table name: blog_countries
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  blog_id    :integer
#  country_id :integer
#
# Indexes
#
#  index_blog_countries_on_blog_id     (blog_id)
#  index_blog_countries_on_country_id  (country_id)
#
