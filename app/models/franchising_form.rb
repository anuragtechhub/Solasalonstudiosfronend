class FranchisingForm < ActiveRecord::Base
  validates :first_name, :last_name, :email_address, :phone_number, :city, :state, :liquid_capital, presence: true
  validate :multi_unit_operator_present
  validates :country, inclusion: { in: %w[usa ca] }
  validates :state, inclusion: { in: USA_STATES.values }, if: proc { self.country.to_s == 'usa' }
  validates :state, inclusion: { in: CA_STATES.values }, if: proc { self.country.to_s == 'ca' }

  after_create :send_email

  scope :usa, -> { where(country: 'usa') }
  scope :ca, -> { where(country: 'ca') }

  def send_email
    p "FranchisingForm after create, send email!"
    Franchising::ApplicationMailer.franchising_form(self).deliver_later
  end

  private

  def multi_unit_operator_present
    errors.add(:base, 'Multi-unit franchise operator can\'t be blank') unless (multi_unit_operator == true || multi_unit_operator == false)
  end
end

# == Schema Information
#
# Table name: franchising_forms
#
#  id                     :integer          not null, primary key
#  agree_to_receive_email :boolean
#  city                   :string(255)
#  country                :string           default("usa"), not null
#  email_address          :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  liquid_capital         :string(255)
#  multi_unit_operator    :boolean
#  phone_number           :string(255)
#  state                  :string(255)
#  utm_campaign           :string(255)
#  utm_content            :string(255)
#  utm_medium             :string(255)
#  utm_source             :string(255)
#  utm_term               :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#
# Indexes
#
#  index_franchising_forms_on_country  (country)
#
