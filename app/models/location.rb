# frozen_string_literal: true

class Location < ActiveRecord::Base
  # include Fuzzily::Model
  # fuzzily_searchable :name, :address_1, :address_2, :city, :state, :postal_code
  include PgSearch::Model
  pg_search_scope :search_by_id, against: [:name, :id, :city, :state, ],
  associated_against: {
    msa: [:name],
    admin: [:email]
  },
  using: {
    tsearch: {
      prefix: true,
      any_word: true
    }
  }

  def self.searchable_columns
    %i[address_1 address_2 city state]
  end

  has_paper_trail

  scope :open, -> { where(status: 'open') }
  scope :with_callfire_ids, lambda {
    where("locations.callfire_list_ids IS NOT NULL AND locations.callfire_list_ids != ''")
  }
  scope :with_mailchimp_list_ids, lambda {
    where("locations.mailchimp_list_ids IS NOT NULL AND locations.mailchimp_list_ids != ''")
  }

  belongs_to :admin
  belongs_to :msa
  has_many :stylists, -> { where(status: 'open') }
  has_many :studios
  has_many :leases
  has_many :external_ids, as: :objectable, dependent: :destroy
  has_many :rent_manager_units, class_name: 'RentManager::Unit', inverse_of: :location, dependent: :destroy
  has_many :connect_maintenance_contacts

  # after_save :submit_to_moz
  before_validation :generate_url_name, on: :create
  after_validation :geocode, if: proc { |location| location.latitude.blank? && location.longitude.blank? }
  before_save :fix_url_name, :prepare_emails, :downcase_email
  # after_destroy :moz_delete, :touch_location
  after_destroy :touch_location
  after_save :update_computed_fields
  geocoded_by :full_address
  after_save :update_stylists_walkins

  after_initialize do
    if new_record?
      self.status ||= 'open'
    end
  end

  has_attached_file :image_1, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_1, content_type: %r{\Aimage/.*\Z}
  attr_accessor :delete_image_1, :delete_image_2, :delete_image_3, :delete_image_4, :delete_image_5, :delete_image_6, :delete_image_7, :delete_image_8, :delete_image_9, :delete_image_10, :delete_image_11, :delete_image_12, :delete_image_13, :delete_image_14, :delete_image_15, :delete_image_16, :delete_image_17, :delete_image_18, :delete_image_19, :delete_image_20, :delete_floorplan_image

  before_validation { image_1.destroy if delete_image_1 == '1' }

  has_attached_file :image_2, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_2, content_type: %r{\Aimage/.*\Z}

  before_validation { image_2.destroy if delete_image_2 == '1' }

  has_attached_file :image_3, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_3, content_type: %r{\Aimage/.*\Z}

  before_validation { image_3.destroy if delete_image_3 == '1' }

  has_attached_file :image_4, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_4, content_type: %r{\Aimage/.*\Z}

  before_validation { image_4.destroy if delete_image_4 == '1' }

  has_attached_file :image_5, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_5, content_type: %r{\Aimage/.*\Z}

  before_validation { image_5.destroy if delete_image_5 == '1' }

  has_attached_file :image_6, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_6, content_type: %r{\Aimage/.*\Z}

  before_validation { image_6.destroy if delete_image_6 == '1' }

  has_attached_file :image_7, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_7, content_type: %r{\Aimage/.*\Z}

  before_validation { image_7.destroy if delete_image_7 == '1' }

  has_attached_file :image_8, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_8, content_type: %r{\Aimage/.*\Z}

  before_validation { image_8.destroy if delete_image_8 == '1' }

  has_attached_file :image_9, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_9, content_type: %r{\Aimage/.*\Z}

  before_validation { image_9.destroy if delete_image_9 == '1' }

  has_attached_file :image_10, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_10, content_type: %r{\Aimage/.*\Z}

  before_validation { image_10.destroy if delete_image_10 == '1' }

  has_attached_file :image_11, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_11, content_type: %r{\Aimage/.*\Z}

  before_validation { image_11.destroy if delete_image_11 == '1' }

  has_attached_file :image_12, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_12, content_type: %r{\Aimage/.*\Z}

  before_validation { image_12.destroy if delete_image_12 == '1' }

  has_attached_file :image_13, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_13, content_type: %r{\Aimage/.*\Z}

  before_validation { image_13.destroy if delete_image_13 == '1' }

  has_attached_file :image_14, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_14, content_type: %r{\Aimage/.*\Z}

  before_validation { image_14.destroy if delete_image_14 == '1' }

  has_attached_file :image_15, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_15, content_type: %r{\Aimage/.*\Z}

  before_validation { image_15.destroy if delete_image_15 == '1' }

  has_attached_file :image_16, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_16, content_type: %r{\Aimage/.*\Z}

  before_validation { image_16.destroy if delete_image_16 == '1' }

  has_attached_file :image_17, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_17, content_type: %r{\Aimage/.*\Z}

  before_validation { image_17.destroy if delete_image_17 == '1' }

  has_attached_file :image_18, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_18, content_type: %r{\Aimage/.*\Z}

  before_validation { image_18.destroy if delete_image_18 == '1' }

  has_attached_file :image_19, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_19, content_type: %r{\Aimage/.*\Z}

  before_validation { image_19.destroy if delete_image_19 == '1' }

  has_attached_file :image_20, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :image_20, content_type: %r{\Aimage/.*\Z}

  before_validation { image_20.destroy if delete_image_20 == '1' }

  has_attached_file :floorplan_image, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https
  validates_attachment_content_type :floorplan_image, content_type: %r{\Aimage/.*\Z}

  before_validation { floorplan_image.destroy if delete_floorplan_image == '1' }

  validates :name, :url_name, presence: true
  validate :url_name_uniqueness
  validates :url_name, uniqueness: true, reduce: true
  validates :country, inclusion: { in: ENV['LOCATION_COUNTRY_INCLUSION'].split(','), message: 'is not valid' }
  validates :description_short, allow_blank: true, length: { maximum: 200 }, format: { with: %r{[0-9\p{L}()\[\] ?:;/!\\,.\-%&=\r\n\t_*§²`´·"'+¡¿@°€£$]} }
  validates :description_long, allow_blank: true, length: { maximum: 1000 }, format: { with: %r{[0-9\p{L}()\[\] ?:;/!\\,.\-%&=\r\n\t_*§²`´·"'+¡¿@°€£$]} }
  # validates :name, :description, :address_1, :city, :state, :postal_code, :phone_number, :email_address_for_inquiries

  def as_json(_options = {})
      super(methods: %i[ msa_name franchisee])
  end

  def msa_name
    msa ? msa.name : ''
  end

  def services
    services = []

    stylists.each do |stylist|
      services += stylist.services(false)
      services << 'Other' if stylist.other_service
    end

    services.uniq.sort
  end

  def keywords
    service_keywords = services
    service_keywords.delete('Other')
    service_keywords.join(', ')
  end

  def status_enum
    [%w[Open open], %w[Closed closed]]
  end

  def service_request_enabled_enum
    [['Yes', true], ['No', false]]
  end

  def max_walkins_time_enum
    (15..480).to_a.in_groups_of(15).collect(&:first).collect { |t| [humanize(t * 60), t] }
  end

  def walkins_enabled_enum
    [['Yes', true], ['No', false]]
  end

  def walkins_timezone_enum
    [['Pacific Time', 'Pacific Time'], ['Mountain Time', 'Mountain Time'], ['Central Time', 'Central Time'], ['Eastern Time', 'Eastern Time']]
  end

  def humanize(secs)
    [[60, :seconds], [60, :minutes], [24, :hours], [Float::INFINITY, :days]].map do |count, name|
      next unless secs.positive?

      secs, n = secs.divmod(count)

      "#{n.to_i} #{name}" unless n.to_i.zero?
    end.compact.reverse.join(' ')
  end

  # DateTime.now.in_time_zone(ActiveSupport::TimeZone.new("Eastern Time (US & Canada)"))
  # DateTime.now.in_time_zone(self.walkins_timezone_offset)
  def walkins_timezone_offset
    return ActiveSupport::TimeZone.new('Pacific Time (US & Canada)') if walkins_timezone == 'Pacific Time'
    return ActiveSupport::TimeZone.new('Mountain Time (US & Canada)') if walkins_timezone == 'Mountain Time'
    return ActiveSupport::TimeZone.new('Central Time (US & Canada)') if walkins_timezone == 'Central Time'
    return ActiveSupport::TimeZone.new('Eastern Time (US & Canada)') if walkins_timezone == 'Eastern Time'
  end

  def walkins_offset
    location_end_offset = DateTime.now.in_time_zone(walkins_timezone_offset).utc_offset / 60 / 60 * 100
    if location_end_offset.abs < 1000
      if location_end_offset.negative?
        "-0#{location_end_offset.abs}"
      else
        "+0#{location_end_offset.abs}"
      end
    else
      "+#{location_end_offset.abs}"
    end
  end

  def downcase_email
    self.email_address_for_hubspot.downcase!
    self.email_address_for_inquiries.downcase!
    self.email_address_for_reports.downcase!
    self.emails_for_stylist_website_approvals.downcase!
    self.rockbot_manager_email.downcase!
  end

  def country_enum
    countries = []

    codes = ENV['LOCATION_COUNTRY_INCLUSION'].split(',')
    names = ENV['LOCATION_COUNTRY_NAMES'].split(',')

    codes.each_with_index do |_code, idx|
      countries << [names[idx].gsub('_', ' '), codes[idx]]
    end

    countries
  end

  def html_address
    address = ''

    address += address_1 if address_1.present?
    address += "<br>#{address_2}" if address_2.present?
    address += '<br>'
    address += "#{city}, #{state} #{postal_code}"

    address
  end

  def street_address
    address = ''

    address += address_1 if address_1.present?
    address += "<br>#{address_2}" if address_2.present?

    address
  end

  def franchisee
    admin.email if admin&.franchisee
  end

  def full_address
    address = ''

    address += address_1.strip if address_1.present?
    address += " #{address_2.strip}" if address_2.present?
    address += ', '
    address += "#{city}, #{state} #{postal_code}"

    address
  end

  # helper function to return images as array
  def images
    imgs = []
    (1..20).each do |num|
      img = send("image_#{num}")
      imgs << img if img.present?
    end
    imgs
  end

  def image_tags
    imgs = []
    (1..20).each do |num|
      img = send("image_#{num}")
      alt = send("image_#{num}_alt_text")
      imgs << "<img src='#{img.url(:carousel)}' alt='#{alt}' />" if img.present?
    end
    imgs
  end

  def social_links_present?
    facebook_url.present? || pinterest_url.present? || twitter_url.present? || instagram_url.present? || yelp_url.present?
  end

  def display_name
    "#{name} (#{city}, #{state})"
  end

  def salon_professionals
    pros = []
    if stylists&.size&.positive?
      stylists.not_reserved.active.find_each do |stylist|
        pros << { id: stylist.id, name: stylist.name, studio_number: stylist.studio_number, business_name: stylist.business_name }
      end
    end
    pros
  end

  def to_param
    "#{state}/#{city}/#{url_name}"
  end

  def website_url
    "https://www.solasalonstudios.com/locations/#{url_name}"
  end

  def canonical_path
    "/locations/#{url_name}"
  end

  def canonical_url
    "https://www.solasalonstudios.#{country == 'CA' ? 'ca' : 'com'}/locations/#{url_name}"
  end

  def services_list
    services.join(', ')
  end

  def tours
    t = []

    if tour_iframe_1.present?
      t << tour_iframe_1
    end

    if tour_iframe_2.present?
      t << tour_iframe_2
    end

    if tour_iframe_3.present?
      t << tour_iframe_3
    end

    t
  end

  def state_province
    states = { 'Alabama'               => 'AL',
               'Alaska'                => 'AK',
               'Alberta'               => 'AB',
               'American Samoa'        => 'AS',
               'Arizona'               => 'AZ',
               'Arkansas'              => 'AR',
               'Armed Forces (AE)'     => 'AE',
               'Armed Forces Americas' => 'AA',
               'Armed Forces Pacific'  => 'AP',
               'British Columbia'      => 'BC',
               'California'            => 'CA',
               'Colorado'              => 'CO',
               'Connecticut'           => 'CT',
               'Delaware'              => 'DE',
               'District Of Columbia'  => 'DC',
               'Florida'               => 'FL',
               'Georgia'               => 'GA',
               'Guam'                  => 'GU',
               'Hawaii'                => 'HI',
               'Idaho'                 => 'ID',
               'Illinois'              => 'IL',
               'Indiana'               => 'IN',
               'Iowa'                  => 'IA',
               'Kansas'                => 'KS',
               'Kentucky'              => 'KY',
               'Louisiana'             => 'LA',
               'Maine'                 => 'ME',
               'Manitoba'              => 'MB',
               'Maryland'              => 'MD',
               'Massachusetts'         => 'MA',
               'Michigan'              => 'MI',
               'Minnesota'             => 'MN',
               'Mississippi'           => 'MS',
               'Missouri'              => 'MO',
               'Montana'               => 'MT',
               'Nebraska'              => 'NE',
               'Nevada'                => 'NV',
               'New Brunswick'         => 'NB',
               'New Hampshire'         => 'NH',
               'New Jersey'            => 'NJ',
               'New Mexico'            => 'NM',
               'New York'              => 'NY',
               'Newfoundland'          => 'NF',
               'North Carolina'        => 'NC',
               'North Dakota'          => 'ND',
               'Northwest Territories' => 'NT',
               'Nova Scotia'           => 'NS',
               'Nunavut'               => 'NU',
               'Ohio'                  => 'OH',
               'Oklahoma'              => 'OK',
               'Ontario'               => 'ON',
               'Oregon'                => 'OR',
               'Pennsylvania'          => 'PA',
               'Prince Edward Island'  => 'PE',
               'Puerto Rico'           => 'PR',
               'Quebec'                => 'QC',
               'Rhode Island'          => 'RI',
               'Saskatchewan'          => 'SK',
               'South Carolina'        => 'SC',
               'South Dakota'          => 'SD',
               'Tennessee'             => 'TN',
               'Texas'                 => 'TX',
               'Utah'                  => 'UT',
               'Vermont'               => 'VT',
               'Virgin Islands'        => 'VI',
               'Virginia'              => 'VA',
               'Washington'            => 'WA',
               'West Virginia'         => 'WV',
               'Wisconsin'             => 'WI',
               'Wyoming'               => 'WY',
               'Yukon Territory'       => 'YT' }

    states[state]
  end

  # TODO: replace this bullshit with friendly_id.
  def fix_url_name
    if url_name.present?
      self.url_name = url_name
        .downcase
        .gsub(/\s+/, '_')
        .gsub(/[^0-9a-zA-Z]/, '_')
        .gsub('___', '_')
        .gsub('_-_', '_')
        .gsub('_', '-')
    end
  end

  def stylists_using_sola_pro
    stylists.where.not(encrypted_password: '')
  end

  def stylists_using_sola_genius
    stylists.select(&:has_sola_genius_account)
  end

  def generate_url_name
    if name && url_name.blank?
      url = name.downcase.gsub(/[^0-9a-zA-Z]/, '-')
      count = 1

      count += 1 while Location.where(url_name: "#{url}#{count}").size.positive?

      self.url_name = "#{url}#{count}"
    end
  end

  def get_moz_token
    moz = Moz.first || Moz.new
    if moz.token.present? && (moz.updated_at.to_date - DateTime.now.to_date).to_i.abs < 14
      Rails.logger.debug { "still within the token date range! return it #{moz.token}" }
    else
      Rails.logger.debug { "get a fresh moz token #{ENV.fetch('MOZ_USER', nil)}, #{ENV.fetch('MOZ_PASS', nil)}" }

      token_response = `curl -X POST https://localapp.moz.com/api/users/login \
        -H 'Content-Type: application/json' \
        -d '{
          "email": "#{ENV.fetch('MOZ_USER', nil)}",
          "password": "#{ENV.fetch('MOZ_PASS', nil)}"
      }'`

      json_token_response = JSON.parse(token_response)

      Rails.logger.debug { "json_token_response=#{json_token_response}" }

      moz.token = json_token_response['response']['access_token']
      moz.save

    end
    moz.token
  rescue StandardError => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
  end

  def rm_location_id
    ExternalId.rent_manager.find_by(
      objectable_type: 'Location',
      objectable_id:   id,
      name:            :location_id
    )&.value&.to_i
  end

  # private

  def url_name_uniqueness
    if url_name
      @stylist = Stylist.find_by(url_name: url_name) || Stylist.find_by(url_name: url_name.split('_').join('-'))
      @location = Location.find_by(url_name: url_name) || Location.find_by(url_name: url_name.split('_').join('-'))

      if @stylist || (@location && @location.id != id)
        errors[:url_name] << 'already in use by another location. Please enter a unique URL name and try again'
      end
    end
  end

  # def get_moz_categories
  #   moz_response = `curl -X GET \
  #     https://localapp.moz.com/api/categories \
  #     -H 'accessToken: #{self.get_moz_token}' \
  #     -H 'Content-Type: application/json' \
  #     -d '{
  #       "language": "en",
  #       "max": 1000
  #   }'`

  #   p "moz_response=#{moz_response}"

  #   json_response = JSON.parse(moz_response)

  #   p "json_response=#{json_response}"
  # end
  def moz_categories
    categories = [109] # Beauty Salon

    services.each do |service|
      categories << 106 if service == 'Hair' && categories.length < 5
      categories << 117 if service == 'Massage' && categories.length < 5
      categories << 1126 if service == 'Nails' && categories.length < 5
      categories << 114 if service == 'Brows' && categories.length < 5
      categories << 116 if service == 'Makeup' && categories.length < 5
      categories << 112 if service == 'Skincare' && categories.length < 5
      categories << 2555 if service == 'Teeth Whitening' && categories.length < 5
      categories << 108 if service == 'Hair Extensions' && categories.length < 5
      categories << 111 if service == 'Hair Removal' && categories.length < 5
      categories << 113 if service == 'Permanent Makeup' && categories.length < 5
    end

    categories
  end

  def moz_opening_hours
    [
      {
        dayOfWeek: 1,
        from1:     open_time.present? ? open_time.strftime('%R') : '08:00',
        to1:       close_time.present? ? close_time.strftime('%R') : '20:00'
      },
      {
        dayOfWeek: 2,
        from1:     open_time.present? ? open_time.strftime('%R') : '08:00',
        to1:       close_time.present? ? close_time.strftime('%R') : '20:00'
      },
      {
        dayOfWeek: 3,
        from1:     open_time.present? ? open_time.strftime('%R') : '08:00',
        to1:       close_time.present? ? close_time.strftime('%R') : '20:00'
      },
      {
        dayOfWeek: 4,
        from1:     open_time.present? ? open_time.strftime('%R') : '08:00',
        to1:       close_time.present? ? close_time.strftime('%R') : '20:00'
      },
      {
        dayOfWeek: 5,
        from1:     open_time.present? ? open_time.strftime('%R') : '08:00',
        to1:       close_time.present? ? close_time.strftime('%R') : '20:00'
      },
      {
        dayOfWeek: 6,
        from1:     open_time.present? ? open_time.strftime('%R') : '08:00',
        to1:       close_time.present? ? close_time.strftime('%R') : '20:00'
      },
      {
        dayOfWeek: 7,
        from1:     open_time.present? ? open_time.strftime('%R') : '08:00',
        to1:       close_time.present? ? close_time.strftime('%R') : '20:00'
      }
    ].to_json
  end

  def moz_payment_options
    %w[VISA MASTERCARD AMEX]
  end

  def moz_create
    Rails.logger.debug 'begin moz_create...'

    businessId = country == 'US' ? 505_116 : 505_117

    moz_response = `curl -X POST \
      https://localapp.moz.com/api/locations \
      -H 'accessToken: #{get_moz_token}' \
      -H 'Content-Type: application/json' \
      -d '{
        "businessId": #{businessId},
        "identifier": #{id},
        "name": "Sola Salon Studios",
        "categories": #{moz_categories},
        "descriptionLong": "#{description_long.presence || moz_long_description}",
        "descriptionShort": "#{description_short.presence || moz_short_description}",
        "openingHours": #{moz_opening_hours},
        "paymentOptions": #{moz_payment_options},
        "keywords": "#{keywords}",
        "services": "#{keywords}",
        "street": "#{address_1}",
        "addressExtra": "#{address_2}",
        "city": "#{city}",
        "province": "#{state_province}",
        "zip": "#{postal_code}",
        "country": "#{country}",
        "phone": "#{phone_number}",
        "website": "https://www.solasalonstudios.com/locations/#{url_name}",
        "email": "#{email_address_for_inquiries}",
        "lat": #{latitude},
        "lng": #{longitude},
        "socialProfiles": #{moz_social_profiles.to_json},
    }'`

    # categories
    # descriptionLong
    # descriptionShort
    # keywords
    # mainPhoto (the first photo?)
    # openingHours
    # photos
    # services
    # socialProfiles

    Rails.logger.debug { "moz_response=#{moz_response}" }
    json_response = JSON.parse(moz_response)

    if json_response && json_response['status'] == 'SUCCESS'
      Rails.logger.debug 'SUCCESS!!!'
      # self.moz_id = #1621670
      update_column(:moz_id, json_response['response']['location']['id'])
    elsif json_response && json_response['status'] == 'CONFLICT' && json_response['response']['duplicates'] && json_response['response']['duplicates'].length == 1
      update_column(:moz_id, json_response['response']['duplicates'][0])
      Rails.logger.debug { "This location already exists in Moz! #{json_response['response']['duplicates']}" }
    end

    submit_photos_to_moz
  end

  def moz_update
    Rails.logger.debug 'begin moz_update...'

    businessId = country == 'US' ? 505_116 : 505_117

    moz_response = `curl -X PATCH \
      https://localapp.moz.com/api/locations/#{moz_id} \
      -H 'accessToken: #{get_moz_token}' \
      -H 'Content-Type: application/json' \
      -d '{
        "businessId": #{businessId},
        "identifier": #{id},
        "name": "Sola Salon Studios",
        "categories": #{moz_categories},
        "descriptionLong": "#{description_long.presence || moz_long_description}",
        "descriptionShort": "#{description_short.presence || moz_short_description}",
        "openingHours": #{moz_opening_hours},
        "paymentOptions": #{moz_payment_options},
        "keywords": "#{keywords}",
        "services": "#{keywords}",
        "street": "#{address_1}",
        "addressExtra": "#{address_2}",
        "city": "#{city}",
        "province": "#{state_province}",
        "zip": "#{postal_code}",
        "country": "#{country}",
        "phone": "#{phone_number}",
        "website": "https://www.solasalonstudios.com/locations/#{url_name}",
        "email": "#{email_address_for_inquiries}",
        "lat": #{latitude},
        "lng": #{longitude},
        "socialProfiles": #{moz_social_profiles.to_json},
        "status": "ACTIVE"
    }'`

    # categories
    # descriptionLong
    # descriptionShort
    # keywords
    # mainPhoto (the first photo?)
    # openingHours
    # photos
    # services
    # DONE - socialProfiles

    Rails.logger.debug { "moz_response=#{moz_response}" }
    json_response = JSON.parse(moz_response)

    submit_photos_to_moz
  end

  def submit_photos_to_moz
    require 'base64'
    require 'down'
    require 'fileutils'

    Rails.logger.debug 'Lastly, we submit photos to Moz...'

    # logo
    c = Curl::Easy.new('https://localapp.moz.com/api/photos') do |curl|
      curl.headers['accessToken'] = get_moz_token
      curl.verbose = true
      curl.multipart_form_post = true
    end

    c.http_post(Curl::PostField.content('description', 'Sola Salon Studios logo'),
                Curl::PostField.content('identifier', "#{id}_logo".to_s),
                Curl::PostField.content('locationId', moz_id.to_s),
                Curl::PostField.content('logo', true.to_s),
                Curl::PostField.content('main', false.to_s),
                Curl::PostField.content('type', 'LOGO'),
                Curl::PostField.file('photo', File.join(Rails.root, 'app', 'assets', 'images', 'logo_blue.png')))

    Rails.logger.debug { "logo response?=#{c.body_str}" }

    # images
    images.each_with_index do |image, idx|
      Rails.logger.debug { "image #{idx}! url=#{image.url(:carousel)}" }
      c = Curl::Easy.new('https://localapp.moz.com/api/photos') do |curl|
        curl.headers['accessToken'] = get_moz_token
        curl.verbose = true
        curl.multipart_form_post = true
      end

      tempfile = Down.download(image.url(:carousel))
      FileUtils.mv(tempfile.path, File.join(Rails.root, 'app', 'assets', 'images', "#{id}_#{idx}".to_s))

      c.http_post(Curl::PostField.content('description', 'Sola Salon Studios image'),
                  Curl::PostField.content('identifier', "#{id}_#{idx}".to_s),
                  Curl::PostField.content('locationId', moz_id.to_s),
                  Curl::PostField.content('logo', false.to_s),
                  Curl::PostField.content('main', idx.zero? ? true.to_s : false.to_s),
                  Curl::PostField.content('type', idx.zero? ? 'MAIN' : 'PHOTO'),
                  Curl::PostField.file('photo', File.join(Rails.root, 'app', 'assets', 'images', "#{id}_#{idx}".to_s)))

      Rails.logger.debug { "image #{idx} response?=#{c.body_str}" }
    end
  end

  # def make_image_local(filename, url)
  #   file = Tempfile.new(filename)
  #   file.binmode
  #   file << open(url).read
  #   file.close
  #   file = File.open(file.path)

  #   return file
  # end

  def moz_delete
    Rails.logger.debug 'begin moz delete...'

    businessId = country == 'US' ? 505_116 : 505_117

    inactivate_response = `curl -X PATCH \
      https://localapp.moz.com/api/locations/#{moz_id} \
      -H 'accessToken: #{get_moz_token}' \
      -H 'Content-Type: application/json' \
      -d '{
        "businessId": #{businessId},
        "name": "Sola Salon Studios",
        "categories": #{moz_categories},
        "descriptionLong": "#{description_long.presence || moz_long_description}",
        "descriptionShort": "#{description_short.presence || moz_short_description}",
        "openingHours": #{moz_opening_hours},
        "paymentOptions": #{moz_payment_options},
        "keywords": "#{keywords}",
        "services": "#{keywords}",
        "street": "#{address_1}",
        "addressExtra": "#{address_2}",
        "city": "#{city}",
        "province": "#{state_province}",
        "zip": "#{postal_code}",
        "country": "#{country}",
        "phone": "#{phone_number}",
        "website": "https://www.solasalonstudios.com/locations/#{url_name}",
        "email": "#{email_address_for_inquiries}",
        "lat": #{latitude},
        "lng": #{longitude},
        "socialProfiles": #{moz_social_profiles.to_json},
        "status": "INACTIVE"
    }'`

    Rails.logger.debug { "inactivate_response=#{inactivate_response}" }

    delete_response = `curl -X DELETE \
      https://localapp.moz.com/api/locations \
      -H 'accessToken: #{get_moz_token}' \
      -H 'Content-Type: application/json' \
      -d '{
        "locations": [#{moz_id}],
    }'`

    Rails.logger.debug { "delete response=#{delete_response}" }
  end

  def submit_to_moz
    Rails.logger.debug 'submit to moz'

    businessId = country == 'US' ? 505_116 : 505_117

    if moz_id.present?
      if status_changed? && self.status == 'closed' && status_was != 'closed'
        Rails.logger.debug 'we just closed a location!!! delete from moz'
        moz_delete
      else
        Rails.logger.debug 'update the location as usual'
        moz_update
      end

    else
      moz_create
    end
    # require 'net/https'
    # require 'json'

    # http = Net::HTTP.new('moz.com', 443)
    # #http = Net::HTTP.new('sandbox.moz.com', 443)
    # http.use_ssl = true

    # http.start do |http|
    #   req = Net::HTTP::Post.new("/local/api/v1/submissions?access_token=JdoGE2CnK7Uj_w9hfkgQduHuKGWLsyGb")

    #   form_data = {}
    #   #form_data['access_token'] = 'JdoGE2CnK7Uj_w9hfkgQduHuKGWLsyGb' #production
    #   #form_data['access_token'] = 'lZfBtREX70Cmn-KkixAWB9uX8l7uW6FL' #sandbox
    #   form_data['name'] = 'Sola Salon Studios'#self.name
    #   form_data['address1'] = self.address_1
    #   form_data['address2'] = self.address_2
    #   form_data['city'] = self.city
    #   form_data['stateProvince'] = self.state_province
    #   form_data['country'] = 'US'
    #   form_data['postalCode'] = self.postal_code
    #   form_data['phone'] = self.phone_number
    #   form_data['email'] = self.email_address_for_inquiries
    #   form_data['description'] = self.description
    #   form_data['categories'] = ['Beauty Salon', 'Hair Salon']
    #   form_data['destinationURL'] = "https://www.solasalonstudios.com/store/#{self.url_name}" #"https://www.solasalonstudios.com/locations/#{self.state}/#{self.city}/#{self.url_name}"

    #   req.set_form_data(form_data)
    #   resp = http.request(req)
    #   p "resp=#{resp.inspect}"
    #   p "resp.body=#{resp.body}"
    # end
    Rails.logger.debug 'DONE WITH MOZ'
  rescue StandardError => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
  end

  def moz_short_description
    short_description = ActionView::Base.full_sanitizer.sanitize(description).strip
    if short_description.length > 197
      short_description = "#{short_description[0...197]}..."
    end
    short_description = short_description.gsub(/&nbsp;/, ' ')
    short_description = short_description.gsub(/&amp;/, 'and')
    short_description = short_description.gsub(/&[a-zA-Z]*;/, '')
    short_description = short_description.gsub(/\r/, '')
    short_description.gsub(/\n/, ' ')
  end

  def moz_long_description
    long_description =
      long_description = ActionView::Base.full_sanitizer.sanitize(description).strip
    if long_description.length > 997
      long_description = "#{long_description[0...997]}..."
    end
    long_description = long_description.gsub(/&nbsp;/, ' ')
    long_description = long_description.gsub(/&amp;/, 'and')
    long_description = long_description.gsub(/&[a-zA-Z]*;/, '')
    long_description = long_description.gsub(/\r/, '')
    long_description.gsub(/\n/, ' ')
  end

  def moz_social_profiles
    social_profiles = []

    social_profiles << { type: 'FACEBOOK', url: facebook_url } if facebook_url.present?
    social_profiles << { type: 'TWITTER', url: twitter_url } if twitter_url.present?
    social_profiles << { type: 'INSTAGRAM', url: instagram_url } if instagram_url.present?
    social_profiles << { type: 'PINTEREST', url: pinterest_url } if pinterest_url.present?

    social_profiles
  end

  def update_computed_fields
    # update stylist location_name
    # if self.name_changed?
    #   stylists.each do |stylist|
    #     stylist.location_name = self.name
    #     stylist.save
    #   end
    # end
  end

  def touch_location
    Location.all.first.touch
  end

  def prepare_emails
    %i[email_address_for_inquiries email_address_for_reports email_address_for_hubspot].each do |key|
      if try(key).present?
        public_send("#{key}=", try(key).to_s.downcase.gsub(/\s+/, ''))
      end
    end
  end

  def update_stylists_walkins
    return unless walkins_enabled_changed?
    return if walkins_enabled

    stylists.update_all(walkins: false)
  end
end

# == Schema Information
#
# Table name: locations
#
#  id                                   :integer          not null, primary key
#  address_1                            :string(255)
#  address_2                            :string(255)
#  callfire_list_ids                    :text
#  chat_code                            :text
#  city                                 :string(255)
#  close_time                           :time
#  country                              :string(255)      default("US")
#  custom_maps_url                      :text
#  description                          :text
#  description_long                     :text
#  description_short                    :text
#  email_address_for_hubspot            :string(255)
#  email_address_for_inquiries          :string(255)
#  email_address_for_reports            :string(255)
#  emails_for_stylist_website_approvals :string
#  facebook_url                         :string(255)
#  floorplan_image_content_type         :string(255)
#  floorplan_image_file_name            :string(255)
#  floorplan_image_file_size            :integer
#  floorplan_image_updated_at           :datetime
#  general_contact_name                 :string(255)
#  image_10_alt_text                    :text
#  image_10_content_type                :string(255)
#  image_10_file_name                   :string(255)
#  image_10_file_size                   :integer
#  image_10_updated_at                  :datetime
#  image_11_alt_text                    :text
#  image_11_content_type                :string(255)
#  image_11_file_name                   :string(255)
#  image_11_file_size                   :integer
#  image_11_updated_at                  :datetime
#  image_12_alt_text                    :text
#  image_12_content_type                :string(255)
#  image_12_file_name                   :string(255)
#  image_12_file_size                   :integer
#  image_12_updated_at                  :datetime
#  image_13_alt_text                    :text
#  image_13_content_type                :string(255)
#  image_13_file_name                   :string(255)
#  image_13_file_size                   :integer
#  image_13_updated_at                  :datetime
#  image_14_alt_text                    :text
#  image_14_content_type                :string(255)
#  image_14_file_name                   :string(255)
#  image_14_file_size                   :integer
#  image_14_updated_at                  :datetime
#  image_15_alt_text                    :text
#  image_15_content_type                :string(255)
#  image_15_file_name                   :string(255)
#  image_15_file_size                   :integer
#  image_15_updated_at                  :datetime
#  image_16_alt_text                    :text
#  image_16_content_type                :string(255)
#  image_16_file_name                   :string(255)
#  image_16_file_size                   :integer
#  image_16_updated_at                  :datetime
#  image_17_alt_text                    :text
#  image_17_content_type                :string(255)
#  image_17_file_name                   :string(255)
#  image_17_file_size                   :integer
#  image_17_updated_at                  :datetime
#  image_18_alt_text                    :text
#  image_18_content_type                :string(255)
#  image_18_file_name                   :string(255)
#  image_18_file_size                   :integer
#  image_18_updated_at                  :datetime
#  image_19_alt_text                    :text
#  image_19_content_type                :string(255)
#  image_19_file_name                   :string(255)
#  image_19_file_size                   :integer
#  image_19_updated_at                  :datetime
#  image_1_alt_text                     :text
#  image_1_content_type                 :string(255)
#  image_1_file_name                    :string(255)
#  image_1_file_size                    :integer
#  image_1_updated_at                   :datetime
#  image_20_alt_text                    :text
#  image_20_content_type                :string(255)
#  image_20_file_name                   :string(255)
#  image_20_file_size                   :integer
#  image_20_updated_at                  :datetime
#  image_2_alt_text                     :text
#  image_2_content_type                 :string(255)
#  image_2_file_name                    :string(255)
#  image_2_file_size                    :integer
#  image_2_updated_at                   :datetime
#  image_3_alt_text                     :text
#  image_3_content_type                 :string(255)
#  image_3_file_name                    :string(255)
#  image_3_file_size                    :integer
#  image_3_updated_at                   :datetime
#  image_4_alt_text                     :text
#  image_4_content_type                 :string(255)
#  image_4_file_name                    :string(255)
#  image_4_file_size                    :integer
#  image_4_updated_at                   :datetime
#  image_5_alt_text                     :text
#  image_5_content_type                 :string(255)
#  image_5_file_name                    :string(255)
#  image_5_file_size                    :integer
#  image_5_updated_at                   :datetime
#  image_6_alt_text                     :text
#  image_6_content_type                 :string(255)
#  image_6_file_name                    :string(255)
#  image_6_file_size                    :integer
#  image_6_updated_at                   :datetime
#  image_7_alt_text                     :text
#  image_7_content_type                 :string(255)
#  image_7_file_name                    :string(255)
#  image_7_file_size                    :integer
#  image_7_updated_at                   :datetime
#  image_8_alt_text                     :text
#  image_8_content_type                 :string(255)
#  image_8_file_name                    :string(255)
#  image_8_file_size                    :integer
#  image_8_updated_at                   :datetime
#  image_9_alt_text                     :text
#  image_9_content_type                 :string(255)
#  image_9_file_name                    :string(255)
#  image_9_file_size                    :integer
#  image_9_updated_at                   :datetime
#  instagram_url                        :string(255)
#  latitude                             :float
#  longitude                            :float
#  mailchimp_list_ids                   :text
#  max_walkins_time                     :integer          default(60)
#  move_in_special                      :text
#  name                                 :string(255)
#  open_house                           :text
#  open_time                            :time
#  phone_number                         :string(255)
#  pinterest_url                        :string(255)
#  postal_code                          :string(255)
#  rent_manager_enabled                 :boolean          default(FALSE)
#  rockbot_manager_email                :string
#  service_request_enabled              :boolean          default(FALSE)
#  state                                :string(255)
#  status                               :string(255)
#  tour_iframe_1                        :text
#  tour_iframe_2                        :text
#  tour_iframe_3                        :text
#  tracking_code                        :text
#  twitter_url                          :string(255)
#  url_name                             :string(255)
#  walkins_enabled                      :boolean          default(FALSE)
#  walkins_end_of_day                   :time
#  walkins_timezone                     :string(255)
#  yelp_url                             :string(255)
#  created_at                           :datetime
#  updated_at                           :datetime
#  admin_id                             :integer
#  legacy_id                            :string(255)
#  moz_id                               :integer
#  msa_id                               :integer
#  rent_manager_location_id             :string(255)
#  rent_manager_property_id             :string(255)
#  store_id                             :string(255)
#
# Indexes
#
#  index_locations_on_admin_id            (admin_id)
#  index_locations_on_country             (country)
#  index_locations_on_msa_id              (msa_id)
#  index_locations_on_state               (state)
#  index_locations_on_status              (status)
#  index_locations_on_status_and_country  (status,country)
#  index_locations_on_url_name            (url_name)
#
