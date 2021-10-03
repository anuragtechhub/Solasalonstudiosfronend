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
#  id                     :integer          not null, primary key
#  author                 :string
#  body                   :text
#  country                :integer
#  image_content_type     :string
#  image_file_name        :string
#  image_file_size        :integer
#  image_updated_at       :datetime
#  kind                   :integer          default(0), not null
#  slug                   :string           not null
#  summary                :text
#  thumbnail_content_type :string
#  thumbnail_file_name    :string
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  title                  :string           not null
#  url                    :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_franchise_articles_on_country  (country)
#  index_franchise_articles_on_slug     (slug) UNIQUE
#  index_franchise_articles_on_title    (title)
#
