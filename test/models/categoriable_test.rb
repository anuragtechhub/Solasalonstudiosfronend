require 'test_helper'

class CategoriableTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: categoriables
#
#  id          :integer          not null, primary key
#  item_type   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  category_id :integer
#  item_id     :integer
#
# Indexes
#
#  index_categoriables_on_category_id            (category_id)
#  index_categoriables_on_item_id_and_item_type  (item_id,item_type)
#
