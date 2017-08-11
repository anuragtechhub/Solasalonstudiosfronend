class Lease < ActiveRecord::Base

  has_paper_trail

  belongs_to :stylist
  belongs_to :studio


end