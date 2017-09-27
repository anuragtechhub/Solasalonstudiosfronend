class Lease < ActiveRecord::Base

  has_paper_trail

  belongs_to :location
  belongs_to :stylist
  belongs_to :studio

  validates :stylist, :location, :weekly_fee_year_1, :weekly_fee_year_2, :fee_start_date, :move_in_date, :start_date, :end_date, :damage_deposit_amount, :presence => true

  def ach_authorized_enum
    [['Yes', true], ['No', false]]
  end

  def facial_permitted_enum
    [['Yes', true], ['No', false]]
  end

  def hair_styling_permitted_enum
    [['Yes', true], ['No', false]]
  end

  def manicure_pedicure_permitted_enum
    [['Yes', true], ['No', false]]
  end

  def massage_permitted_enum
    [['Yes', true], ['No', false]]
  end

  def sola_provided_insurance_enum
    [['Yes', true], ['No', false]]
  end

  def waxing_permitted_enum
    [['Yes', true], ['No', false]]
  end

end