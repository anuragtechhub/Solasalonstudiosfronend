class Brandable < ActiveRecord::Base
  belongs_to :brand, inverse_of: :brandables
  belongs_to :item, inverse_of: :brandables, polymorphic: true
end

# == Schema Information
#
# Table name: brandables
#
#  id         :integer          not null, primary key
#  brand_id   :integer
#  item_id    :integer
#  item_type  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_brandables_on_brand_id               (brand_id)
#  index_brandables_on_item_type_and_item_id  (item_type,item_id)
#
# Foreign Keys
#
#  brandables_brand_id_fk  (brand_id => brands.id)
#
