class Lease < ActiveRecord::Base

  has_paper_trail

  belongs_to :location
  belongs_to :stylist
  belongs_to :studio

  validates :location, :stylist, :studio, :presence => true
  validates :weekly_fee_year_1, :weekly_fee_year_2, :fee_start_date, :move_in_date, :start_date, :end_date, :damage_deposit_amount, :presence => true, :if => lambda { self.studio.present? }
  validates :weekly_fee_year_1, :weekly_fee_year_2, numericality: { greater_than: 0 }, :if => lambda { self.studio.present? }
  validate :end_date_later_than_start_date, :end_date_at_least_a_year_later_than_start_date, :fee_start_date_not_after_end_date, :fee_start_date_a_year_before_end_date, :if => lambda { self.studio.present? }

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

  def end_date_later_than_start_date
    if start_date && end_date && (end_date <= start_date)
      errors.add(:end_date, 'must be later than the start date')
    end
  end

  def end_date_at_least_a_year_later_than_start_date
    if start_date && end_date && (end_date > start_date) && (((end_date - start_date) / 365).floor < 1)
      errors.add(:end_date, 'must be at least one year later than the start date')
    end
  end

  def fee_start_date_not_after_end_date
    if fee_start_date && end_date && fee_start_date > end_date
      errors.add(:fee_start_date, 'cannot be later than the end date')
    end
  end

  def fee_start_date_a_year_before_end_date
    if fee_start_date && end_date && (((end_date - fee_start_date) / 365).floor < 1)
      errors.add(:fee_start_date, 'must be at least one year before the end date')
    end
  end

  def as_json(options={})
    super(:methods => [:location, :studio])
  end

end