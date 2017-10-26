class Lease < ActiveRecord::Base

  has_paper_trail

  belongs_to :location
  belongs_to :stylist
  belongs_to :studio

  belongs_to :recurring_charge_1, :class_name => 'RecurringCharge', :foreign_key => 'recurring_charge_1_id'
  accepts_nested_attributes_for :recurring_charge_1, :allow_destroy => true

  belongs_to :recurring_charge_2, :class_name => 'RecurringCharge', :foreign_key => 'recurring_charge_2_id'
  accepts_nested_attributes_for :recurring_charge_2, :allow_destroy => true

  belongs_to :recurring_charge_3, :class_name => 'RecurringCharge', :foreign_key => 'recurring_charge_3_id'
  accepts_nested_attributes_for :recurring_charge_3, :allow_destroy => true

  belongs_to :recurring_charge_4, :class_name => 'RecurringCharge', :foreign_key => 'recurring_charge_4_id'
  accepts_nested_attributes_for :recurring_charge_4, :allow_destroy => true    

  validates :location, :stylist, :studio, :presence => true
  validates :move_in_date, :start_date, :end_date, :damage_deposit_amount, :presence => true, :if => lambda { self.studio.present? }
  validate :end_date_later_than_start_date, :end_date_at_least_a_year_later_than_start_date, :if => lambda { self.studio.present? }

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

  def as_json(options={})
    super(:methods => [:location, :studio])
  end

end