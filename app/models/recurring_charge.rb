class RecurringCharge < ActiveRecord::Base

  validates :amount, :start_date, :end_date, :presence => true
  validates :amount, numericality: { greater_than: 0 }, :if => lambda { self.amount.present? }
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    if (start_date && end_date) && (end_date <= start_date)
      errors.add(:base, 'end date must be later than the start date')
    end
  end

end