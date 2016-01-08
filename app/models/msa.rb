class Msa < ActiveRecord::Base

  after_save :update_computed_fields
  after_destroy :touch_msa
  has_many :locations

  private

  def update_computed_fields
    self.locations.each do |location|
      # update stylist location_name
      location.stylists.each do |stylist|
        stylist.msa_name = self.name
        stylist.save
      end
    end
  end

  def touch_msa
    Msa.all.first.touch
  end
end