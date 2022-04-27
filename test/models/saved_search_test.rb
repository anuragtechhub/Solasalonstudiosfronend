# frozen_string_literal: true

require 'test_helper'

class SavedSearchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: saved_searches
#
#  id         :integer          not null, primary key
#  kind       :string(255)
#  query      :text             not null
#  created_at :datetime
#  updated_at :datetime
#  admin_id   :integer
#  stylist_id :integer
#
# Indexes
#
#  index_saved_searches_on_admin_id    (admin_id)
#  index_saved_searches_on_kind        (kind)
#  index_saved_searches_on_query       (query)
#  index_saved_searches_on_stylist_id  (stylist_id)
#
