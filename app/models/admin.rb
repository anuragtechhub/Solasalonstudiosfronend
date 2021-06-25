class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  has_many :locations

  has_paper_trail

  #validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, :allow_blank => true
  #validates :email, :uniqueness => true, if: 'email.present?'
  validates :password, :presence => true, :on => :create, :reduce => true
  #validates :password, :length => { :minimum => 7 }

  scope :with_callfire_credentials, -> {
    where.not(callfire_app_login: nil, callfire_app_password: nil).
      where.not(callfire_app_login: '', callfire_app_password: '')
  }

  scope :with_mailchimp_credentials, -> {
    where.not(mailchimp_api_key: nil).where.not(mailchimp_api_key: '')
  }

  def self.current
    Thread.current[:admin]
  end

  def self.current=(admin)
    Thread.current[:admin] = admin
  end

  def title
    email
  end

  def location_ids
    locations.pluck(:id) if locations
  end

  def forgot_password
    self.forgot_password_key = "#{SecureRandom.urlsafe_base64(3).gsub(/-|_/, '')}#{SecureRandom.hex(3)}".split('').shuffle.join
    if self.save
      email = PublicWebsiteMailer.forgot_password(self)
      if email && email.deliver
        true
      else
        false
      end
    else
      false
    end
  end
end

# == Schema Information
#
# Table name: admins
#
#  id                     :integer          not null, primary key
#  callfire_app_login     :string(255)
#  callfire_app_password  :string(255)
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :citext           default(""), not null
#  email_address          :citext           not null
#  encrypted_password     :string(255)      default("")
#  forgot_password_key    :string(255)
#  franchisee             :boolean
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  mailchimp_api_key      :string(255)
#  onboarded              :boolean          default(FALSE), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0), not null
#  sola_pro_country_admin :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  legacy_id              :string(255)
#
# Indexes
#
#  index_admins_on_email                 (email) UNIQUE
#  index_admins_on_email_address         (email_address)
#  index_admins_on_reset_password_token  (reset_password_token) UNIQUE
#
