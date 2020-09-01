class Taggable < ActiveRecord::Base
  belongs_to :tag
  belongs_to :item, polymorphic: true
end

# == Schema Information
#
# Table name: taggables
#
#  id         :integer          not null, primary key
#  tag_id     :integer
#  item_id    :integer
#  item_type  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_taggables_on_item_type_and_item_id  (item_type,item_id)
#  index_taggables_on_tag_id                 (tag_id)
#
# Foreign Keys
#
#  taggables_tag_id_fk  (tag_id => tags.id)
#
