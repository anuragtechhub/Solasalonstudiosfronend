class Studio < ActiveRecord::Base
  
  has_paper_trail

  before_save :set_location_name
  belongs_to :location
  belongs_to :stylist

  def title
    if self.location_name.present?
      "#{self.location_name}: #{self.name}"
    else
      name
    end
  end

  private

  def set_location_name
    self.location_name = self.location.name if self.location
  end

end

# == Schema Information
#
# Table name: studios
#
#  id              :integer          not null, primary key
#  location_name   :string(255)
#  name            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  location_id     :integer
#  rent_manager_id :string(255)
#  stylist_id      :integer
#
# Indexes
#
#  index_studios_on_location_id  (location_id)
#  index_studios_on_stylist_id   (stylist_id)
#
