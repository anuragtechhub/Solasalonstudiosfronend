class Location < ActiveRecord::Base

  # include Fuzzily::Model
  # fuzzily_searchable :name, :address_1, :address_2, :city, :state, :postal_code
  def self.searchable_columns
    [:address_1, :address_2, :city, :state]
  end

  has_paper_trail

  scope :open, -> { where(:status => 'open') }

  belongs_to :admin
  belongs_to :msa
  has_many :stylists, -> { where(:status => 'open') }
  has_many :studios

  #after_save :submit_to_moz
  before_validation :generate_url_name, :on => :create
  before_save :fix_url_name
  after_save :update_computed_fields
  after_validation :geocode, if: Proc.new { |location| location.latitude.blank? && location.longitude.blank? }
  geocoded_by :full_address
  after_destroy :touch_location

  after_initialize do
    if new_record?
      self.status ||= 'open'
    end
  end

  has_attached_file :image_1, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_1, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_1
  before_validation { self.image_1.destroy if self.delete_image_1 == '1' }

  has_attached_file :image_2, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_2, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_2
  before_validation { self.image_2.destroy if self.delete_image_2 == '1' }

  has_attached_file :image_3, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_3, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_3
  before_validation { self.image_3.destroy if self.delete_image_3 == '1' }

  has_attached_file :image_4, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_4, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_4
  before_validation { self.image_4.destroy if self.delete_image_4 == '1' }

  has_attached_file :image_5, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_5, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_5
  before_validation { self.image_5.destroy if self.delete_image_5 == '1' }

  has_attached_file :image_6, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_6, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_6
  before_validation { self.image_6.destroy if self.delete_image_6 == '1' }

  has_attached_file :image_7, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_7, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_7
  before_validation { self.image_7.destroy if self.delete_image_7 == '1' }

  has_attached_file :image_8, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_8, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_8
  before_validation { self.image_8.destroy if self.delete_image_8 == '1' }

  has_attached_file :image_9, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_9, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_9
  before_validation { self.image_9.destroy if self.delete_image_9 == '1' }

  has_attached_file :image_10, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_10, :content_type => /\Aimage\/.*\Z/              
  attr_accessor :delete_image_10
  before_validation { self.image_10.destroy if self.delete_image_10 == '1' }

  has_attached_file :image_11, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_11, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_11
  before_validation { self.image_11.destroy if self.delete_image_11 == '1' }

  has_attached_file :image_12, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_12, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_12
  before_validation { self.image_12.destroy if self.delete_image_12 == '1' }

  has_attached_file :image_13, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_13, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_13
  before_validation { self.image_13.destroy if self.delete_image_13 == '1' }

  has_attached_file :image_14, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_14, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_14
  before_validation { self.image_14.destroy if self.delete_image_14 == '1' }

  has_attached_file :image_15, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_15, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_15
  before_validation { self.image_15.destroy if self.delete_image_15 == '1' }

  has_attached_file :image_16, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_16, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_16
  before_validation { self.image_16.destroy if self.delete_image_16 == '1' }

  has_attached_file :image_17, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_17, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_17
  before_validation { self.image_17.destroy if self.delete_image_17 == '1' }

  has_attached_file :image_18, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_18, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_18
  before_validation { self.image_18.destroy if self.delete_image_18 == '1' }

  has_attached_file :image_19, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_19, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_19
  before_validation { self.image_19.destroy if self.delete_image_19 == '1' }

  has_attached_file :image_20, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https 
  validates_attachment_content_type :image_20, :content_type => /\Aimage\/.*\Z/                         
  attr_accessor :delete_image_20
  before_validation { self.image_20.destroy if self.delete_image_20 == '1' }                   

  validates :name, :url_name, :presence => true
  validate :url_name_uniqueness
  validates :url_name, :uniqueness => true, :reduce => true
  validates :country, inclusion: { in: ENV['LOCATION_COUNTRY_INCLUSION'].split(','), message: "is not valid" }
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

  def status_enum
    [['Open', 'open'], ['Closed', 'closed']]
  end

  def service_request_enabled_enum
    [['Yes', true], ['No', false]]
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
      stylists.each do |stylist|
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
      self.url_name = self.url_name.gsub(/[^0-9a-zA-Z]/, '_')
      self.url_name = self.url_name.gsub('___', '_')
      self.url_name = self.url_name.gsub('_-_', '_')
      self.url_name = self.url_name.split('_')
      self.url_name = self.url_name.map{ |u| u.downcase }
      self.url_name = self.url_name.join('-')
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

  private

  def url_name_uniqueness
    if self.url_name
      @stylist = Stylist.find_by(:url_name => self.url_name) || Stylist.find_by(:url_name => self.url_name.split('_').join('-'))
      @location = Location.find_by(:url_name => self.url_name) || Location.find_by(:url_name => self.url_name.split('_').join('-'))

      if @stylist || (@location && @location.id != self.id)
        errors[:url_name] << 'already in use by another location. Please enter a unique URL name and try again'
      end
    end
  end

  def submit_to_moz
    p "submit to moz"
    require 'net/https'
    require 'json'

    http = Net::HTTP.new('moz.com', 443)
    #http = Net::HTTP.new('sandbox.moz.com', 443)
    http.use_ssl = true

    http.start do |http|
      req = Net::HTTP::Post.new("/local/api/v1/submissions?access_token=JdoGE2CnK7Uj_w9hfkgQduHuKGWLsyGb")

      form_data = {}
      #form_data['access_token'] = 'JdoGE2CnK7Uj_w9hfkgQduHuKGWLsyGb' #production
      #form_data['access_token'] = 'lZfBtREX70Cmn-KkixAWB9uX8l7uW6FL' #sandbox
      form_data['name'] = 'Sola Salon Studios'#self.name
      form_data['address1'] = self.address_1
      form_data['address2'] = self.address_2
      form_data['city'] = self.city
      form_data['stateProvince'] = self.state_province
      form_data['country'] = 'US'
      form_data['postalCode'] = self.postal_code
      form_data['phone'] = self.phone_number
      form_data['email'] = self.email_address_for_inquiries
      form_data['description'] = self.description
      form_data['categories'] = ['Beauty Salon', 'Hair Salon']
      form_data['destinationURL'] = "https://www.solasalonstudios.com/store/#{self.url_name}" #"https://www.solasalonstudios.com/locations/#{self.state}/#{self.city}/#{self.url_name}"

      req.set_form_data(form_data)
      resp = http.request(req)
      p "resp=#{resp.inspect}"
      p "resp.body=#{resp.body}"
    end
  end

  def update_computed_fields
    # update stylist location_name
    if self.name_changed?
      stylists.each do |stylist|
        stylist.location_name = self.name
        stylist.save
      end
    end
  end

  def touch_location
    Location.all.first.touch
  end



end