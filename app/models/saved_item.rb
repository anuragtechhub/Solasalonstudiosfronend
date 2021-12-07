class SavedItem < ActiveRecord::Base
  belongs_to :stylist
  belongs_to :admin
  belongs_to :item, polymorphic: true

  ALLOWED_TYPES = %w[SolaClass Tool Video].freeze

  validates :item_id, presence: true, numericality: { only_integer: true }
  validates :item_type, presence: true, inclusion: { in: ALLOWED_TYPES }
end

# == Schema Information
#
# Table name: saved_items
#
#  id         :integer          not null, primary key
#  item_type  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  admin_id   :integer
#  item_id    :integer
#  stylist_id :integer
#
# Indexes
#
#  index_saved_items_on_admin_id               (admin_id)
#  index_saved_items_on_item_type_and_item_id  (item_type,item_id)
#  index_saved_items_on_stylist_id             (stylist_id)
#
