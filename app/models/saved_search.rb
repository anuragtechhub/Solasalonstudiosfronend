class SavedSearch < ActiveRecord::Base
  belongs_to :sola_stylist
  belongs_to :admin

  validates :query, presence: true
  validates :sola_stylist_id, presence: true, if: proc { self.admin_id.blank? }
  validates :admin_id, presence: true, if: proc { self.sola_stylist_id.blank? }
end
