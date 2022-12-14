# frozen_string_literal: true

class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include PgSearch::Model
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable # , :validatable

  pg_search_scope :search_admin, against: [:email, :email_address],
  using: {
      tsearch: {
        prefix: true
      }
    }
  has_many :locations

  #### Sola PRO ####
  has_many :sola_classes
  has_many :reset_passwords, as: :userable
  has_many :devices, as: :userable
  has_many :user_notifications, as: :userable
  has_many :watch_laters, as: :userable
  has_many :video_views, as: :userable
  has_many :saved_items, inverse_of: :admin, dependent: :destroy
  has_many :saved_searches, inverse_of: :admin, dependent: :destroy
  has_many :taggables, as: :item, dependent: :destroy
  has_many :tags, through: :taggables
  has_many :brandables, as: :item, dependent: :destroy
  has_many :brands, through: :brandables
  has_many :categoriables, as: :item, dependent: :destroy
  has_many :categories, through: :categoriables
  has_many :events, as: :userable
  has_many :access_tokens, class_name: 'UserAccessToken', inverse_of: :admin, dependent: :delete_all

  # TMP.
  attr_accessor :sola_pro_platform, :sola_pro_version

  has_paper_trail

  # validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, :allow_blank => true
  # validates :email, :uniqueness => true, if: 'email.present?'
  validates :password, presence: true, on: :create, reduce: true
  # validates :password, :length => { :minimum => 7 }

  scope :with_callfire_credentials, lambda {
    where.not(callfire_app_login: [nil, ''], callfire_app_password: [nil, ''])
  }

  scope :with_mailchimp_credentials, lambda {
    where.not(mailchimp_api_key: nil).where.not(mailchimp_api_key: '')
  }

  ### Sola Pro ###
  def device_token
    if devices&.length&.positive?
      devices.order(updated_at: :desc).first.token
    end
  end

  def notifications
    user_notifications.where(dismiss_date: nil)
  end

  def userable_email
    return email if self.class.method_defined?('email') && email.present?
    return email_address if self.class.method_defined?('email_address') && email_address.present?
  end

  def video_history_data
    v_videos = VideoView.where(id: VideoView.select('DISTINCT ON (video_id) *').where(userable_id: id, userable_type: self.class.name).map(&:id)).order(:created_at)

    if v_videos&.size
      {
        total_pages: (v_videos.size / 12) + ((v_videos.size % 12).zero? ? 0 : 1),
        videos:      v_videos.limit(12).to_a.map(&:video)
      }
    else
      {
        total_pages: 0,
        videos:      []
      }
    end
  end

  def watch_later_data
    w_videos = WatchLater.where(userable_id: id, userable_type: self.class.name).order(:created_at)

    if w_videos&.size
      {
        total_pages: (w_videos.size / 12) + ((w_videos.size % 12).zero? ? 0 : 1),
        videos:      w_videos.limit(12).to_a.map(&:video)
      }
    else
      {
        total_pages: 0,
        videos:      []
      }
    end
  end

  def watch_later_video_ids
    watch_laters.pluck(:video_id)
  end

  def update_my_sola_website
    nil
  end

  def location_country
    if sola_pro_country_admin.present?
      sola_pro_country_admin
    elsif locations && locations.size >= 1
      locations.first.country
    elsif ENV.fetch('DEFAULT_LOCALE', nil) == 'pt-BR'
      'BR'
    else
      'US'
    end
  end

  def app_settings
    {
      home_buttons:     HomeButton.joins(:home_button_countries, :countries).where(countries: { code: location_country }).uniq.order(:position),
      home_hero_images: HomeHeroImage.joins(:home_hero_image_countries, :countries).where(countries: { code: location_country }).uniq.order(:position),
      side_menu_items:  SideMenuItem.joins(:side_menu_item_countries, :countries).where(countries: { code: location_country }).uniq.order(:position)
    }
  end

  def service_request_enabled
    !!locations.first&.service_request_enabled
  end

  def location_walkins_enabled
    !!location&.walkins_enabled
  end

  def walkins_offset
    !!location&.walkins_offset
  end

  def max_walkins_time
    !!location&.max_walkins_time
  end

  def walkins_end_of_day
    !!location&.walkins_end_of_day
  end

  def rent_manager_enabled
    !!locations.first&.rent_manager_enabled
  end

  # def as_json(_options = {})
  #   super(methods: %i[location_country notifications update_my_sola_website
  #                     video_history_data watch_later_video_ids watch_later_data app_settings
  #                     service_request_enabled rent_manager_enabled tags brands])
  # end

  def as_json(_options = {})
    super(methods: %i[last_sign_in_at sign_in_count])
  end
  
  ### End Sola Pro ###

  def self.current
    Thread.current[:admin]
  end

  def last_sign_in_at
    self[:last_sign_in_at]
  end 

  def sign_in_count
    self[:sign_in_count]
  end 

  def self.current=(admin)
    Thread.current[:admin] = admin
  end

  def title
    email
  end

  def location_ids
    locations&.ids
  end

  def forgot_password
    self.forgot_password_key = "#{SecureRandom.urlsafe_base64(3).gsub(/-|_/, '')}#{SecureRandom.hex(3)}".chars.shuffle.join
    if save
      email = PublicWebsiteMailer.forgot_password(self)
      if email&.deliver
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
#  email_address          :citext
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
