class Lease < ActiveRecord::Base

  has_paper_trail

  belongs_to :stylist
  belongs_to :studio

  def sola_provided_insurance_enum
    [['Yes', true], ['No', false]]
  end

  def ach_authorized_enum
    [['Yes', true], ['No', false]]
  end

end