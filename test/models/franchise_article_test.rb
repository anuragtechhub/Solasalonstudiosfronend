require 'test_helper'

class FranchiseArticleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: franchise_articles
#
#  id                 :integer          not null, primary key
#  author             :string
#  body               :text
#  country            :integer
#  image_content_type :string
#  image_file_name    :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  slug               :string           not null
#  summary            :text
#  title              :string           not null
#  url                :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_franchise_articles_on_country  (country)
#  index_franchise_articles_on_slug     (slug) UNIQUE
#  index_franchise_articles_on_title    (title)
#
