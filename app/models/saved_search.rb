# frozen_string_literal: true

class SavedSearch < ActiveRecord::Base
  belongs_to :stylist
  belongs_to :admin

  validates :query, presence: true
  validates :stylist_id, presence: true, if: proc { admin_id.blank? }
  validates :admin_id, presence: true, if: proc { stylist_id.blank? }

  def self.save_for_user(user, query, kind)
    user.saved_searches.find_by(query: query, kind: kind)&.touch ||
      user.saved_searches.create(query: query, kind: kind)
  end
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
