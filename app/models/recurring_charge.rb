class RecurringCharge < ActiveRecord::Base

  validates :amount, :start_date, :end_date, :presence => true
  validates :amount, numericality: { greater_than: 0 }, :if => lambda { self.amount.present? }
  validate :end_date_after_start_date

  HUMANIZED_ATTRIBUTES = {
    :amount => "weekly fee"
  }

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  private

  def end_date_after_start_date
    if (start_date && end_date) && (end_date <= start_date)
      errors.add(:base, 'end date must be later than the start date')
    end
  end

end

# == Schema Information
#
# Table name: recurring_charges
#
#  id          :integer          not null, primary key
#  amount      :integer
#  charge_type :string(255)
#  end_date    :date
#  position    :integer
#  start_date  :date
#  created_at  :datetime
#  updated_at  :datetime
#  lease_id    :integer
#
# Indexes
#
#  index_recurring_charges_on_lease_id  (lease_id)
#
