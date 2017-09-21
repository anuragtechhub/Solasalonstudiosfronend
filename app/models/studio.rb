class Studio < ActiveRecord::Base
  
  has_paper_trail

  before_save :set_location_name
  belongs_to :location
  belongs_to :stylist

  def title
    if location_name
      "#{location_name}: #{name}"
    else
      name
    end
  end

  private

  def set_location_name
    self.location_name = self.location.name if self.location
  end

end