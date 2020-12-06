class Location < ActiveRecord::Base

  # include Fuzzily::Model
  # fuzzily_searchable :name, :address_1, :address_2, :city, :state, :postal_code
  def self.searchable_columns
    [:address_1, :address_2, :city, :state]
  end

  has_paper_trail

  scope :open, -> { where(status: 'open') }

  belongs_to :admin
  belongs_to :msa
  has_many :stylists, -> { where(:status => 'open') }
  has_many :studios
  has_many :leases

  # after_save :submit_to_moz
  before_validation :generate_url_name, :on => :create
  before_save :fix_url_name, :prepare_emails
  after_save :update_computed_fields
  after_validation :geocode, if: Proc.new { |location| location.latitude.blank? && location.longitude.blank? }
  geocoded_by :full_address
  #after_destroy :moz_delete, :touch_location
  after_destroy :touch_location
  after_save :update_stylists_walkins

  after_initialize do
    if new_record?
      self.status ||= 'open'
    end
  end

  has_attached_file :image_1, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_1, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_1
  before_validation { self.image_1.destroy if self.delete_image_1 == '1' }

  has_attached_file :image_2, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_2, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_2
  before_validation { self.image_2.destroy if self.delete_image_2 == '1' }

  has_attached_file :image_3, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_3, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_3
  before_validation { self.image_3.destroy if self.delete_image_3 == '1' }

  has_attached_file :image_4, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_4, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_4
  before_validation { self.image_4.destroy if self.delete_image_4 == '1' }

  has_attached_file :image_5, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_5, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_5
  before_validation { self.image_5.destroy if self.delete_image_5 == '1' }

  has_attached_file :image_6, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_6, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_6
  before_validation { self.image_6.destroy if self.delete_image_6 == '1' }

  has_attached_file :image_7, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_7, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_7
  before_validation { self.image_7.destroy if self.delete_image_7 == '1' }

  has_attached_file :image_8, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_8, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_8
  before_validation { self.image_8.destroy if self.delete_image_8 == '1' }

  has_attached_file :image_9, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_9, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_9
  before_validation { self.image_9.destroy if self.delete_image_9 == '1' }

  has_attached_file :image_10, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_10, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_10
  before_validation { self.image_10.destroy if self.delete_image_10 == '1' }

  has_attached_file :image_11, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_11, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_11
  before_validation { self.image_11.destroy if self.delete_image_11 == '1' }

  has_attached_file :image_12, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_12, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_12
  before_validation { self.image_12.destroy if self.delete_image_12 == '1' }

  has_attached_file :image_13, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_13, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_13
  before_validation { self.image_13.destroy if self.delete_image_13 == '1' }

  has_attached_file :image_14, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_14, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_14
  before_validation { self.image_14.destroy if self.delete_image_14 == '1' }

  has_attached_file :image_15, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_15, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_15
  before_validation { self.image_15.destroy if self.delete_image_15 == '1' }

  has_attached_file :image_16, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_16, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_16
  before_validation { self.image_16.destroy if self.delete_image_16 == '1' }

  has_attached_file :image_17, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_17, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_17
  before_validation { self.image_17.destroy if self.delete_image_17 == '1' }

  has_attached_file :image_18, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_18, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_18
  before_validation { self.image_18.destroy if self.delete_image_18 == '1' }

  has_attached_file :image_19, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_19, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_19
  before_validation { self.image_19.destroy if self.delete_image_19 == '1' }

  has_attached_file :image_20, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image_20, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_20
  before_validation { self.image_20.destroy if self.delete_image_20 == '1' }

  has_attached_file :floorplan_image, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :floorplan_image, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_floorplan_image
  before_validation { self.floorplan_image.destroy if self.delete_floorplan_image == '1' }

  validates :name, :url_name, :presence => true
  validate :url_name_uniqueness
  validates :url_name, :uniqueness => true, :reduce => true
  validates :country, inclusion: { in: ENV['LOCATION_COUNTRY_INCLUSION'].split(','), message: "is not valid" }
  validates :description_short, :allow_blank => true, length: { maximum: 200 }, format: { with: /[0-9\p{L}\(\)\[\] \?:;\/!\\,\.\-%\\&=\r\n\t_\*§²`´·"'\+¡¿@°€£$]/ }
  validates :description_long, :allow_blank => true, length: { maximum: 1000 }, format: { with: /[0-9\p{L}\(\)\[\] \?:;\/!\\,\.\-%\\&=\r\n\t_\*§²`´·"'\+¡¿@°€£$]/ }
  # validates :name, :description, :address_1, :city, :state, :postal_code, :phone_number, :email_address_for_inquiries

  def msa_name
    msa ? msa.name : ''
  end

  def services
    services = []

    stylists.each do |stylist|
      services = services + stylist.services(false)
      services << 'Other' if stylist.other_service
    end

    services.uniq.sort
  end

  def keywords
    service_keywords = self.services
    service_keywords.delete('Other')
    service_keywords.join(', ')
  end

  def status_enum
    [['Open', 'open'], ['Closed', 'closed']]
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
    [[60, :seconds], [60, :minutes], [24, :hours], [Float::INFINITY, :days]].map{ |count, name|
      if secs > 0
        secs, n = secs.divmod(count)

        "#{n.to_i} #{name}" unless n.to_i==0
      end
    }.compact.reverse.join(' ')
  end
  # DateTime.now.in_time_zone(ActiveSupport::TimeZone.new("Eastern Time (US & Canada)"))
  # DateTime.now.in_time_zone(self.walkins_timezone_offset)
  def walkins_timezone_offset
    return ActiveSupport::TimeZone.new("Pacific Time (US & Canada)") if self.walkins_timezone == 'Pacific Time'
    return ActiveSupport::TimeZone.new("Mountain Time (US & Canada)") if self.walkins_timezone == 'Mountain Time'
    return ActiveSupport::TimeZone.new("Central Time (US & Canada)") if self.walkins_timezone == 'Central Time'
    return ActiveSupport::TimeZone.new("Eastern Time (US & Canada)") if self.walkins_timezone == 'Eastern Time'
  end

  def walkins_offset
    location_end_offset = DateTime.now.in_time_zone(self.walkins_timezone_offset).utc_offset / 60 / 60 * 100
    if location_end_offset.abs < 1000
      if location_end_offset < 0
        location_end_offset = '-0' + location_end_offset.abs.to_s
      else
        location_end_offset = '+0' + location_end_offset.abs.to_s
      end
    else
      location_end_offset = '+' + location_end_offset.abs.to_s
    end
    return location_end_offset
  end

  def country_enum
    countries = []

    codes = ENV['LOCATION_COUNTRY_INCLUSION'].split(',')
    names = ENV['LOCATION_COUNTRY_NAMES'].split(',')

    codes.each_with_index do |code, idx|
      countries << [names[idx].gsub('_', ' '), codes[idx]]
    end

    countries
  end

  def html_address
    address = ''

    address += address_1 if address_1.present?
    address += '<br>' + address_2 if address_2.present?
    address += '<br>'
    address += "#{city}, #{state} #{postal_code}"

    return address
  end

  def street_address
    address = ''

    address += address_1 if address_1.present?
    address += '<br>' + address_2 if address_2.present?

    return address
  end

  def franchisee
    admin.email if admin && admin.franchisee
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
      img = self.send("image_#{num}")
      imgs << img if img.present?
    end
    imgs
  end

  def image_tags
    imgs = []
    (1..20).each do |num|
      img = self.send("image_#{num}")
      alt = self.send("image_#{num}_alt_text")
      imgs << "<img src='#{img.url(:carousel)}' alt='#{alt if alt}' />" if img.present?
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
    if stylists && stylists.size > 0
      stylists.not_reserved.each do |stylist|
        pros << {:id => stylist.id, :name => stylist.name, :studio_number => stylist.studio_number, :business_name => stylist.business_name}
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

    if self.tour_iframe_1.present?
      t << self.tour_iframe_1
    end

    if self.tour_iframe_2.present?
      t << self.tour_iframe_2
    end

    if self.tour_iframe_3.present?
      t << self.tour_iframe_3
    end

    return t
  end

  def state_province
    states = {"Alabama" => "AL",
              "Alaska" => "AK",
              "Alberta" => "AB",
              "American Samoa" => "AS",
              "Arizona" => "AZ",
              "Arkansas" => "AR",
              "Armed Forces (AE)" => "AE",
              "Armed Forces Americas" => "AA",
              "Armed Forces Pacific" => "AP",
              "British Columbia" => "BC",
              "California" => "CA",
              "Colorado" => "CO",
              "Connecticut" => "CT",
              "Delaware" => "DE",
              "District Of Columbia" => "DC",
              "Florida" => "FL",
              "Georgia" => "GA",
              "Guam" => "GU",
              "Hawaii" => "HI",
              "Idaho" => "ID",
              "Illinois" => "IL",
              "Indiana" => "IN",
              "Iowa" => "IA",
              "Kansas" => "KS",
              "Kentucky" => "KY",
              "Louisiana" => "LA",
              "Maine" => "ME",
              "Manitoba" => "MB",
              "Maryland" => "MD",
              "Massachusetts" => "MA",
              "Michigan" => "MI",
              "Minnesota" => "MN",
              "Mississippi" => "MS",
              "Missouri" => "MO",
              "Montana" => "MT",
              "Nebraska" => "NE",
              "Nevada" => "NV",
              "New Brunswick" => "NB",
              "New Hampshire" => "NH",
              "New Jersey" => "NJ",
              "New Mexico" => "NM",
              "New York" => "NY",
              "Newfoundland" => "NF",
              "North Carolina" => "NC",
              "North Dakota" => "ND",
              "Northwest Territories" => "NT",
              "Nova Scotia" => "NS",
              "Nunavut" => "NU",
              "Ohio" => "OH",
              "Oklahoma" => "OK",
              "Ontario" => "ON",
              "Oregon" => "OR",
              "Pennsylvania" => "PA",
              "Prince Edward Island" => "PE",
              "Puerto Rico" => "PR",
              "Quebec" => "QC",
              "Rhode Island" => "RI",
              "Saskatchewan" => "SK",
              "South Carolina" => "SC",
              "South Dakota" => "SD",
              "Tennessee" => "TN",
              "Texas" => "TX",
              "Utah" => "UT",
              "Vermont" => "VT",
              "Virgin Islands" => "VI",
              "Virginia" => "VA",
              "Washington" => "WA",
              "West Virginia" => "WV",
              "Wisconsin" => "WI",
              "Wyoming" => "WY",
              "Yukon Territory" => "YT"}

    states[self.state]
  end

  def fix_url_name
    if self.url_name.present?
      self.url_name = self.url_name
                        .gsub(/[^0-9a-zA-Z]/, '_')
                        .gsub('___', '_')
                        .gsub('_-_', '_')
                        .split('_')
                        .map{ |u| u.downcase }
                        .join('-')
    end
  end

  def stylists_using_sola_pro
    stylists.where('encrypted_password != ?', '')
  end

  def stylists_using_sola_genius
    stylists.select{|s| s.has_sola_genius_account }
  end

  def generate_url_name
    if self.name && self.url_name.blank?
      url = self.name.downcase.gsub(/[^0-9a-zA-Z]/, '-')
      count = 1

      while Location.where(:url_name => "#{url}#{count}").size > 0 do
        count = count + 1
      end

      self.url_name = "#{url}#{count}"
    end
  end

  def get_moz_token
    moz = Moz.first || Moz.new
    if moz.token.present? && (moz.updated_at.to_date - DateTime.now.to_date).to_i.abs < 14
      p "still within the token date range! return it #{moz.token}"
      return moz.token
    else
      p "get a fresh moz token #{ENV['MOZ_USER']}, #{ENV['MOZ_PASS']}"

      token_response = `curl -X POST https://localapp.moz.com/api/users/login \
        -H 'Content-Type: application/json' \
        -d '{
          "email": "#{ENV['MOZ_USER']}",
          "password": "#{ENV['MOZ_PASS']}"
      }'`

      json_token_response = JSON.parse(token_response)

      p "json_token_response=#{json_token_response}"

      moz.token = json_token_response['response']['access_token']
      moz.save

      return moz.token
    end
  rescue => e
    p "error with get moz token #{e}"
  end

  #private

  def url_name_uniqueness
    if self.url_name
      @stylist = Stylist.find_by(:url_name => self.url_name) || Stylist.find_by(:url_name => self.url_name.split('_').join('-'))
      @location = Location.find_by(:url_name => self.url_name) || Location.find_by(:url_name => self.url_name.split('_').join('-'))

      if @stylist || (@location && @location.id != self.id)
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

    self.services.each do |service|
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
            "dayOfWeek": 1,
            "from1": self.open_time.present? ? self.open_time.strftime('%R') : '08:00',
            "to1": self.close_time.present? ? self.close_time.strftime('%R') : '20:00'
        },
        {
            "dayOfWeek": 2,
            "from1": self.open_time.present? ? self.open_time.strftime('%R') : '08:00',
            "to1": self.close_time.present? ? self.close_time.strftime('%R') : '20:00'
        },
        {
            "dayOfWeek": 3,
            "from1": self.open_time.present? ? self.open_time.strftime('%R') : '08:00',
            "to1": self.close_time.present? ? self.close_time.strftime('%R') : '20:00'
        },
        {
            "dayOfWeek": 4,
            "from1": self.open_time.present? ? self.open_time.strftime('%R') : '08:00',
            "to1": self.close_time.present? ? self.close_time.strftime('%R') : '20:00'
        },
        {
            "dayOfWeek": 5,
            "from1": self.open_time.present? ? self.open_time.strftime('%R') : '08:00',
            "to1": self.close_time.present? ? self.close_time.strftime('%R') : '20:00'
        },
        {
            "dayOfWeek": 6,
            "from1": self.open_time.present? ? self.open_time.strftime('%R') : '08:00',
            "to1": self.close_time.present? ? self.close_time.strftime('%R') : '20:00'
        },
        {
            "dayOfWeek": 7,
            "from1": self.open_time.present? ? self.open_time.strftime('%R') : '08:00',
            "to1": self.close_time.present? ? self.close_time.strftime('%R') : '20:00'
        }
    ].to_json
  end

  def moz_payment_options
    ['VISA', 'MASTERCARD', 'AMEX']
  end

  def moz_create
    p "begin moz_create..."

    businessId = self.country == 'US' ? 505116 : 505117

    moz_response = `curl -X POST \
      https://localapp.moz.com/api/locations \
      -H 'accessToken: #{self.get_moz_token}' \
      -H 'Content-Type: application/json' \
      -d '{
        "businessId": #{businessId},
        "identifier": #{self.id},
        "name": "Sola Salon Studios",
        "categories": #{self.moz_categories},
        "descriptionLong": "#{self.description_long.present? ? self.description_long : self.moz_long_description}",
        "descriptionShort": "#{self.description_short.present? ? self.description_short : self.moz_short_description}",
        "openingHours": #{self.moz_opening_hours},
        "paymentOptions": #{self.moz_payment_options},
        "keywords": "#{self.keywords}",
        "services": "#{self.keywords}",
        "street": "#{self.address_1}",
        "addressExtra": "#{self.address_2}",
        "city": "#{self.city}",
        "province": "#{self.state_province}",
        "zip": "#{self.postal_code}",
        "country": "#{self.country}",
        "phone": "#{self.phone_number}",
        "website": "https://www.solasalonstudios.com/locations/#{self.url_name}",
        "email": "#{self.email_address_for_inquiries}",
        "lat": #{self.latitude},
        "lng": #{self.longitude},
        "socialProfiles": #{self.moz_social_profiles.to_json},
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

    p "moz_response=#{moz_response}"
    json_response = JSON.parse(moz_response)

    if json_response && json_response["status"] == "SUCCESS"
      p "SUCCESS!!!"
      #self.moz_id = #1621670
      self.update_column(:moz_id, json_response["response"]["location"]["id"])
    elsif json_response && json_response["status"] == "CONFLICT" && json_response["response"]["duplicates"] && json_response["response"]["duplicates"].length == 1
      self.update_column(:moz_id, json_response["response"]["duplicates"][0])
      p "This location already exists in Moz! #{json_response["response"]["duplicates"]}"
    end

    self.submit_photos_to_moz
  end

  def moz_update
    p "begin moz_update..."

    businessId = self.country == 'US' ? 505116 : 505117

    moz_response = `curl -X PATCH \
      https://localapp.moz.com/api/locations/#{self.moz_id} \
      -H 'accessToken: #{self.get_moz_token}' \
      -H 'Content-Type: application/json' \
      -d '{
        "businessId": #{businessId},
        "identifier": #{self.id},
        "name": "Sola Salon Studios",
        "categories": #{self.moz_categories},
        "descriptionLong": "#{self.description_long.present? ? self.description_long : self.moz_long_description}",
        "descriptionShort": "#{self.description_short.present? ? self.description_short : self.moz_short_description}",
        "openingHours": #{self.moz_opening_hours},
        "paymentOptions": #{self.moz_payment_options},
        "keywords": "#{self.keywords}",
        "services": "#{self.keywords}",
        "street": "#{self.address_1}",
        "addressExtra": "#{self.address_2}",
        "city": "#{self.city}",
        "province": "#{self.state_province}",
        "zip": "#{self.postal_code}",
        "country": "#{self.country}",
        "phone": "#{self.phone_number}",
        "website": "https://www.solasalonstudios.com/locations/#{self.url_name}",
        "email": "#{self.email_address_for_inquiries}",
        "lat": #{self.latitude},
        "lng": #{self.longitude},
        "socialProfiles": #{self.moz_social_profiles.to_json},
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

    p "moz_response=#{moz_response}"
    json_response = JSON.parse(moz_response)

    self.submit_photos_to_moz
  end

  def submit_photos_to_moz
    require 'base64'
    require "down"
    require "fileutils"

    p "Lastly, we submit photos to Moz..."

    # logo
    c = Curl::Easy.new("https://localapp.moz.com/api/photos") do |curl|
      curl.headers["accessToken"] = self.get_moz_token
      curl.verbose = true
      curl.multipart_form_post = true
    end

    c.http_post(Curl::PostField.content('description', "Sola Salon Studios logo"),
      Curl::PostField.content('identifier', "#{self.id.to_s + '_logo'}"),
      Curl::PostField.content('locationId', self.moz_id.to_s),
      Curl::PostField.content('logo', true.to_s),
      Curl::PostField.content('main', false.to_s),
      Curl::PostField.content('type', "LOGO"),
      Curl::PostField.file('photo', File.join(Rails.root, 'app', 'assets', 'images', 'logo_blue.png')))

    p "logo response?=#{c.body_str}"

    # images
    self.images.each_with_index do |image, idx|
      p "image #{idx}! url=#{image.url(:carousel)}"
      c = Curl::Easy.new("https://localapp.moz.com/api/photos") do |curl|
        curl.headers["accessToken"] = self.get_moz_token
        curl.verbose = true
        curl.multipart_form_post = true
      end

      tempfile = Down.download(image.url(:carousel))
      FileUtils.mv(tempfile.path, File.join(Rails.root, 'app', 'assets', 'images', "#{self.id.to_s + '_' + idx.to_s}"))

      c.http_post(Curl::PostField.content('description', "Sola Salon Studios image"),
        Curl::PostField.content('identifier', "#{self.id.to_s + '_' + idx.to_s}"),
        Curl::PostField.content('locationId', self.moz_id.to_s),
        Curl::PostField.content('logo', false.to_s),
        Curl::PostField.content('main', idx == 0 ? true.to_s : false.to_s),
        Curl::PostField.content('type', idx == 0 ? "MAIN" : "PHOTO"),
        Curl::PostField.file('photo', File.join(Rails.root, 'app', 'assets', 'images', "#{self.id.to_s + '_' + idx.to_s}") ))

      p "image #{idx} response?=#{c.body_str}"
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
    p "begin moz delete..."

    businessId = self.country == 'US' ? 505116 : 505117

    inactivate_response = `curl -X PATCH \
      https://localapp.moz.com/api/locations/#{self.moz_id} \
      -H 'accessToken: #{self.get_moz_token}' \
      -H 'Content-Type: application/json' \
      -d '{
        "businessId": #{businessId},
        "name": "Sola Salon Studios",
        "categories": #{self.moz_categories},
        "descriptionLong": "#{self.description_long.present? ? self.description_long : self.moz_long_description}",
        "descriptionShort": "#{self.description_short.present? ? self.description_short : self.moz_short_description}",
        "openingHours": #{self.moz_opening_hours},
        "paymentOptions": #{self.moz_payment_options},
        "keywords": "#{self.keywords}",
        "services": "#{self.keywords}",
        "street": "#{self.address_1}",
        "addressExtra": "#{self.address_2}",
        "city": "#{self.city}",
        "province": "#{self.state_province}",
        "zip": "#{self.postal_code}",
        "country": "#{self.country}",
        "phone": "#{self.phone_number}",
        "website": "https://www.solasalonstudios.com/locations/#{self.url_name}",
        "email": "#{self.email_address_for_inquiries}",
        "lat": #{self.latitude},
        "lng": #{self.longitude},
        "socialProfiles": #{self.moz_social_profiles.to_json},
        "status": "INACTIVE"
    }'`

    p "inactivate_response=#{inactivate_response}"

    delete_response = `curl -X DELETE \
      https://localapp.moz.com/api/locations \
      -H 'accessToken: #{self.get_moz_token}' \
      -H 'Content-Type: application/json' \
      -d '{
        "locations": [#{self.moz_id}],
    }'`

    p "delete response=#{delete_response}"
  end

  def submit_to_moz
    p "submit to moz"

    businessId = self.country == 'US' ? 505116 : 505117

    if self.moz_id.present?
      if self.status_changed? && self.status == 'closed' && self.status_was != 'closed'
        p "we just closed a location!!! delete from moz"
        self.moz_delete
      else
        p "update the location as usual"
        self.moz_update
      end

    else
      self.moz_create
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
    p "DONE WITH MOZ"
  rescue => e
    p "Error with Moz location submission #{e}"
  end

  def moz_short_description
    short_description = ActionView::Base.full_sanitizer.sanitize(self.description).strip
    if short_description.length > 197
      short_description = short_description[0...197] + '...'
    end
    short_description = short_description.gsub(/&nbsp;/, ' ')
    short_description = short_description.gsub(/&amp;/, 'and')
    short_description = short_description.gsub(/&[a-zA-Z]*;/, '')
    short_description = short_description.gsub(/\r/, '')
    short_description = short_description.gsub(/\n/, ' ')
    return short_description
  end

  def moz_long_description
    long_description =
    long_description = ActionView::Base.full_sanitizer.sanitize(self.description).strip
    if long_description.length > 997
      long_description = long_description[0...997] + '...'
    end
    long_description = long_description.gsub(/&nbsp;/, ' ')
    long_description = long_description.gsub(/&amp;/, 'and')
    long_description = long_description.gsub(/&[a-zA-Z]*;/, '')
    long_description = long_description.gsub(/\r/, '')
    long_description = long_description.gsub(/\n/, ' ')
    return long_description
  end

  def moz_social_profiles
    social_profiles = []

    social_profiles << {type: 'FACEBOOK', url: self.facebook_url} if self.facebook_url.present?
    social_profiles << {type: 'TWITTER', url: self.twitter_url} if self.twitter_url.present?
    social_profiles << {type: 'INSTAGRAM', url: self.instagram_url} if self.instagram_url.present?
    social_profiles << {type: 'PINTEREST', url: self.pinterest_url} if self.pinterest_url.present?

    return social_profiles
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
      if self.try(key).present?
        public_send("#{key}=", self.try(key).to_s.downcase.gsub(/\s+/, ''))
      end
    end
  end

  def update_stylists_walkins
    return unless self.walkins_enabled_changed?
    return if self.walkins_enabled

    stylists.update_all(walkins: false)
  end
end

# == Schema Information
#
# Table name: locations
#
#  id                           :integer          not null, primary key
#  name                         :string(255)
#  url_name                     :string(255)
#  address_1                    :string(255)
#  address_2                    :string(255)
#  city                         :string(255)
#  state                        :string(255)
#  postal_code                  :string(255)
#  email_address_for_inquiries  :string(255)
#  phone_number                 :string(255)
#  general_contact_name         :string(255)
#  description                  :text
#  facebook_url                 :string(255)
#  twitter_url                  :string(255)
#  latitude                     :float
#  longitude                    :float
#  created_at                   :datetime
#  updated_at                   :datetime
#  chat_code                    :text
#  image_1_file_name            :string(255)
#  image_1_content_type         :string(255)
#  image_1_file_size            :integer
#  image_1_updated_at           :datetime
#  image_2_file_name            :string(255)
#  image_2_content_type         :string(255)
#  image_2_file_size            :integer
#  image_2_updated_at           :datetime
#  image_3_file_name            :string(255)
#  image_3_content_type         :string(255)
#  image_3_file_size            :integer
#  image_3_updated_at           :datetime
#  image_4_file_name            :string(255)
#  image_4_content_type         :string(255)
#  image_4_file_size            :integer
#  image_4_updated_at           :datetime
#  image_5_file_name            :string(255)
#  image_5_content_type         :string(255)
#  image_5_file_size            :integer
#  image_5_updated_at           :datetime
#  image_6_file_name            :string(255)
#  image_6_content_type         :string(255)
#  image_6_file_size            :integer
#  image_6_updated_at           :datetime
#  image_7_file_name            :string(255)
#  image_7_content_type         :string(255)
#  image_7_file_size            :integer
#  image_7_updated_at           :datetime
#  image_8_file_name            :string(255)
#  image_8_content_type         :string(255)
#  image_8_file_size            :integer
#  image_8_updated_at           :datetime
#  image_9_file_name            :string(255)
#  image_9_content_type         :string(255)
#  image_9_file_size            :integer
#  image_9_updated_at           :datetime
#  image_10_file_name           :string(255)
#  image_10_content_type        :string(255)
#  image_10_file_size           :integer
#  image_10_updated_at          :datetime
#  legacy_id                    :string(255)
#  image_11_file_name           :string(255)
#  image_11_content_type        :string(255)
#  image_11_file_size           :integer
#  image_11_updated_at          :datetime
#  image_12_file_name           :string(255)
#  image_12_content_type        :string(255)
#  image_12_file_size           :integer
#  image_12_updated_at          :datetime
#  image_13_file_name           :string(255)
#  image_13_content_type        :string(255)
#  image_13_file_size           :integer
#  image_13_updated_at          :datetime
#  image_14_file_name           :string(255)
#  image_14_content_type        :string(255)
#  image_14_file_size           :integer
#  image_14_updated_at          :datetime
#  image_15_file_name           :string(255)
#  image_15_content_type        :string(255)
#  image_15_file_size           :integer
#  image_15_updated_at          :datetime
#  image_16_file_name           :string(255)
#  image_16_content_type        :string(255)
#  image_16_file_size           :integer
#  image_16_updated_at          :datetime
#  image_17_file_name           :string(255)
#  image_17_content_type        :string(255)
#  image_17_file_size           :integer
#  image_17_updated_at          :datetime
#  image_18_file_name           :string(255)
#  image_18_content_type        :string(255)
#  image_18_file_size           :integer
#  image_18_updated_at          :datetime
#  image_19_file_name           :string(255)
#  image_19_content_type        :string(255)
#  image_19_file_size           :integer
#  image_19_updated_at          :datetime
#  image_20_file_name           :string(255)
#  image_20_content_type        :string(255)
#  image_20_file_size           :integer
#  image_20_updated_at          :datetime
#  status                       :string(255)
#  admin_id                     :integer
#  msa_id                       :integer
#  move_in_special              :text
#  open_house                   :text
#  pinterest_url                :string(255)
#  instagram_url                :string(255)
#  yelp_url                     :string(255)
#  mailchimp_list_ids           :text
#  callfire_list_ids            :text
#  custom_maps_url              :text
#  tracking_code                :text
#  tour_iframe_1                :text
#  tour_iframe_2                :text
#  tour_iframe_3                :text
#  country                      :string(255)      default("US")
#  image_1_alt_text             :text
#  image_2_alt_text             :text
#  image_3_alt_text             :text
#  image_4_alt_text             :text
#  image_5_alt_text             :text
#  image_6_alt_text             :text
#  image_7_alt_text             :text
#  image_8_alt_text             :text
#  image_9_alt_text             :text
#  image_10_alt_text            :text
#  image_11_alt_text            :text
#  image_12_alt_text            :text
#  image_13_alt_text            :text
#  image_14_alt_text            :text
#  image_15_alt_text            :text
#  image_16_alt_text            :text
#  image_17_alt_text            :text
#  image_18_alt_text            :text
#  image_19_alt_text            :text
#  image_20_alt_text            :text
#  email_address_for_reports    :string(255)
#  rent_manager_property_id     :string(255)
#  rent_manager_location_id     :string(255)
#  service_request_enabled      :boolean          default(FALSE)
#  rent_manager_enabled         :boolean          default(FALSE)
#  moz_id                       :integer
#  description_short            :text
#  description_long             :text
#  open_time                    :time
#  close_time                   :time
#  walkins_enabled              :boolean          default(FALSE)
#  max_walkins_time             :integer          default(60)
#  walkins_end_of_day           :time
#  walkins_timezone             :string(255)
#  floorplan_image_file_name    :string(255)
#  floorplan_image_content_type :string(255)
#  floorplan_image_file_size    :integer
#  floorplan_image_updated_at   :datetime
#  store_id                     :string(255)
#  email_address_for_hubspot    :string(255)
#
# Indexes
#
#  index_locations_on_admin_id  (admin_id)
#  index_locations_on_msa_id    (msa_id)
#  index_locations_on_state     (state)
#  index_locations_on_status    (status)
#  index_locations_on_url_name  (url_name)
#
