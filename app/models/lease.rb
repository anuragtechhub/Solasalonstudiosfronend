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

  # validates :location, :stylist, :studio, :presence => true
  # validates :move_in_date, :start_date, :end_date, :damage_deposit_amount, :presence => true, :if => lambda { self.studio.present? }
  # validate :end_date_later_than_start_date, :end_date_at_least_a_year_later_than_start_date, :if => lambda { self.studio.present? }

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
    super(:methods => [:location, :studio, :recurring_charge_1, :recurring_charge_2, :recurring_charge_3, :recurring_charge_4])
  end

end

# == Schema Information
#
# Table name: leases
#
#  id                          :integer          not null, primary key
#  ach_authorized              :boolean          default(FALSE)
#  agreement_file_url          :text
#  cable                       :boolean          default(FALSE)
#  create_date                 :date
#  damage_deposit_amount       :integer
#  end_date                    :date
#  facial_permitted            :boolean          default(FALSE)
#  fee_start_date              :date
#  hair_styling_permitted      :boolean          default(FALSE)
#  insurance                   :boolean          default(FALSE)
#  insurance_amount            :integer
#  insurance_frequency         :string(255)
#  insurance_start_date        :date
#  manicure_pedicure_permitted :boolean          default(FALSE)
#  massage_permitted           :boolean          default(FALSE)
#  move_in_bonus               :boolean          default(FALSE)
#  move_in_bonus_amount        :integer
#  move_in_bonus_payee         :string(255)
#  move_in_date                :date
#  move_out_date               :date
#  nsf_fee_amount              :integer
#  other_service               :string(255)
#  parking                     :boolean          default(FALSE)
#  product_bonus_amount        :integer
#  product_bonus_distributor   :string(255)
#  signed_date                 :date
#  special_terms               :text
#  start_date                  :date
#  taxes                       :boolean          default(FALSE)
#  waxing_permitted            :boolean          default(FALSE)
#  weekly_fee_year_1           :integer
#  weekly_fee_year_2           :integer
#  created_at                  :datetime
#  updated_at                  :datetime
#  location_id                 :integer
#  rent_manager_id             :string(255)
#  studio_id                   :integer
#  stylist_id                  :integer
#
# Indexes
#
#  index_leases_on_location_id  (location_id)
#  index_leases_on_studio_id    (studio_id)
#  index_leases_on_stylist_id   (stylist_id)
#
