class Studio < ActiveRecord::Base
  
  has_paper_trail

  belongs_to :location
  belongs_to :stylist

  def title
    if location && location.name
      "#{location.name}: #{name}"
    else
      name
    end
  end

  # def location_name
  #   location.name if location
  # end
end