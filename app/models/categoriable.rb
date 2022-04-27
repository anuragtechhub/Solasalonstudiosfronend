# frozen_string_literal: true

class Categoriable < ActiveRecord::Base
  belongs_to :category
  belongs_to :item, polymorphic: true
end

# == Schema Information
#
# Table name: categoriables
#
#  id          :integer          not null, primary key
#  category_id :integer
#  item_id     :integer
#  item_type   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_categoriables_on_category_id            (category_id)
#  index_categoriables_on_item_id_and_item_type  (item_id,item_type)
#
