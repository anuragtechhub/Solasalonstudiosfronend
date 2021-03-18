class SavedSearch < ActiveRecord::Base
  belongs_to :sola_stylist
  belongs_to :admin

  validates :query, presence: true
  validates :sola_stylist_id, presence: true, if: proc { self.admin_id.blank? }
  validates :admin_id, presence: true, if: proc { self.sola_stylist_id.blank? }
end

# == Schema Information
#
# Table name: saved_searches
#
#  id              :integer          not null, primary key
#  kind            :string(255)
#  query           :text             not null
#  created_at      :datetime
#  updated_at      :datetime
#  admin_id        :integer
#  sola_stylist_id :integer
#
# Indexes
#
#  index_saved_searches_on_admin_id         (admin_id)
#  index_saved_searches_on_kind             (kind)
#  index_saved_searches_on_query            (query)
#  index_saved_searches_on_sola_stylist_id  (sola_stylist_id)
#
