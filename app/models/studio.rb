class Studio < ActiveRecord::Base
  
  has_paper_trail

  belongs_to :stylist

end