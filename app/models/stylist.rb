class Stylist < ActiveRecord::Base

  # include Fuzzily::Model
  # fuzzily_searchable :name, :email_address
  def self.searchable_columns
    [:name, :email_address]
  end


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :authentication_keys => [:email_address]
  devise :registerable, :recoverable, :rememberable, :trackable

  has_paper_trail
  
  scope :open, -> { where(:status => 'open') }

  after_initialize do
    if new_record?
      self.status ||= 'open'
    end
  end

  before_validation :generate_url_name, :on => :create
  belongs_to :location
  before_save :update_computed_fields, :fix_url_name
  after_create :create_on_rent_manager
  after_save :remove_from_mailchimp_if_closed
  after_destroy :remove_from_mailchimp, :touch_stylist

  has_one :studio
  has_many :leases
  accepts_nested_attributes_for :leases, :allow_destroy => true

  belongs_to :testimonial_1, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_1'
  accepts_nested_attributes_for :testimonial_1, :allow_destroy => true

  belongs_to :testimonial_2, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_2'
  accepts_nested_attributes_for :testimonial_2, :allow_destroy => true

  belongs_to :testimonial_3, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_3'
  accepts_nested_attributes_for :testimonial_3, :allow_destroy => true

  belongs_to :testimonial_4, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_4'
  accepts_nested_attributes_for :testimonial_4, :allow_destroy => true

  belongs_to :testimonial_5, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_5'
  accepts_nested_attributes_for :testimonial_5, :allow_destroy => true

  belongs_to :testimonial_6, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_6'
  accepts_nested_attributes_for :testimonial_6, :allow_destroy => true

  belongs_to :testimonial_7, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_7'
  accepts_nested_attributes_for :testimonial_7, :allow_destroy => true

  belongs_to :testimonial_8, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_8'
  accepts_nested_attributes_for :testimonial_8, :allow_destroy => true

  belongs_to :testimonial_9, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_9'
  accepts_nested_attributes_for :testimonial_9, :allow_destroy => true

  belongs_to :testimonial_10, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_10'
  accepts_nested_attributes_for :testimonial_10, :allow_destroy => true

  has_attached_file :image_1, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_1, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_1
  before_validation { self.image_1.destroy if self.delete_image_1 == '1' }

  has_attached_file :image_2, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_2, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_2
  before_validation { self.image_2.destroy if self.delete_image_2 == '1' }

  has_attached_file :image_3, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_3, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_3
  before_validation { self.image_3.destroy if self.delete_image_3 == '1' }

  has_attached_file :image_4, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_4, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_4
  before_validation { self.image_4.destroy if self.delete_image_4 == '1' }

  has_attached_file :image_5, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_5, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_5
  before_validation { self.image_5.destroy if self.delete_image_5 == '1' }

  has_attached_file :image_6, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_6, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_6
  before_validation { self.image_6.destroy if self.delete_image_6 == '1' }

  has_attached_file :image_7, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_7, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_7
  before_validation { self.image_7.destroy if self.delete_image_7 == '1' }

  has_attached_file :image_8, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_8, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_8
  before_validation { self.image_8.destroy if self.delete_image_8 == '1' }

  has_attached_file :image_9, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_9, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_9
  before_validation { self.image_9.destroy if self.delete_image_9 == '1' }

  has_attached_file :image_10, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_10, :content_type => /\Aimage\/.*\Z/    
  attr_accessor :delete_image_10
  before_validation { self.image_10.destroy if self.delete_image_10 == '1' }

  validates :email_address, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, :allow_blank => true, :on => :create
  #validates :email_address, :uniqueness => true, if: 'email_address.present?'
  
  validates :name, :url_name, :presence => true
  #validates :other_service, length: {maximum: 18}, allow_blank: true
  validate :url_name_uniqueness

  def first_name
    FullNameSplitter.split(name)[0]
  end

  def last_name
    FullNameSplitter.split(name)[1]
  end

  def social_links_present?
    facebook_url.present? || pinterest_url.present? || twitter_url.present? || instagram_url.present? || linkedin_url.present? || yelp_url.present? || google_plus_url.present?
  end

  def status_enum
    [['Open', 'open'], ['Closed', 'closed']]
  end

  def send_a_message_button_enum
    [['Visible', true], ['Hidden', false]]
  end

  def phone_number_display_enum
    [['Visible', true], ['Hidden', false]]
  end

  def sola_genius_enabled_enum
    [['Yes', true], ['No', false]]
  end

  def has_sola_genius_account_enum
    [['Yes', true], ['No', false]]
  end

  # helper function to return images as array
  def images
    images_array = []
    (1..10).each do |num|
      image = self.send("image_#{num}")
      images_array << image if image.present?
    end
    images_array
  end

  def image_tags
    images_array = []
    (1..10).each do |num|
      image = self.send("image_#{num}")
      alt = self.send("image_#{num}_alt_text")
      images_array << "<img src='#{image.url(:carousel)}' alt='#{alt if alt}' />" if image.present?
    end
    images_array
  end

  def services(show_other = true) 
    services = []

    services << 'Brows' if brows
    services << 'Hair' if hair
    services << 'Hair Extensions' if hair_extensions
    services << 'Laser Hair Removal' if laser_hair_removal
    services << 'Lashes' if eyelash_extensions
    services << 'Makeup' if makeup
    services << 'Massage' if massage
    services << 'Microblading' if microblading
    services << 'Nails' if nails
    services << 'Permanent Makeup' if permanent_makeup
    services << 'Skincare' if skin
    services << 'Tanning' if tanning
    services << 'Teeth Whitening' if teeth_whitening
    services << 'Threading' if threading
    services << 'Waxing' if waxing
    services << other_service if (show_other && other_service.present?)

    services
  end

  # helper function to return testimonials as array
  def testimonials
    testimonial_array = []
    (1..10).each do |num|
      testimonial = self.send("testimonial_#{num}")
      testimonial_array << testimonial if testimonial.present?
    end
    testimonial_array
  end

  def to_param
    url_name
  end

  def update_computed_fields
    self.location_name = location.name if location && location.name
    if location && location.msa
      self.msa_name = location.msa.name 
    end
  end

  def has_sola_pro_login
    self.encrypted_password.present?
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

  def canonical_path
    "/salon-professional/#{url_name}"
  end

  def canonical_url
    "https://www.solasalonstudios.#{location && location.country == 'CA' ? 'ca' : 'com'}/salon-professional/#{url_name}"
  end

  def create_on_rent_manager
    if location && location.rent_manager_property_id.present? && location.rent_manager_location_id.present?
      require 'rest-client'
      p "Sync stylist with Rent Manager: rent_manager_property_id=#{location.rent_manager_property_id}, rent_manager_location_id=#{location.rent_manager_location_id}"
      
      payload = {
        "FirstName" => self.first_name,
        "LastName" => self.last_name,
        "PropertyID" => self.location.rent_manager_property_id,
      }

      payload["TenantID"] = self.rent_manager_id if self.rent_manager_id.present?

      p "payload=#{payload}"

      post_tenant_response = RestClient::Request.execute({
        :headers => {"Content-Type": "application/json"},
        :method => :post, 
        #:content_type => 'application/json',
        :url => "https://solasalon.apiservices.rentmanager.com/api/#{location.rent_manager_location_id}/tenants", 
        :user => 'solapro', 
        :password => '20FCEF93-AD4D-4C7D-9B78-BA2492098481',
        :payload => [payload].to_json
      })

      post_tenant_response_json = JSON.parse(post_tenant_response)[0]
      p "post_tenant_response_json=#{post_tenant_response_json}"
      if post_tenant_response_json["TenantID"] && post_tenant_response_json["TenantID"] != self.rent_manager_id
        p "let's store the rent_manager_id #{post_tenant_response_json["TenantID"]}"
        self.rent_manager_id = post_tenant_response_json["TenantID"]
        self.save
      else
        p "no rent_manager_id or same rent_manager_id, so no need to save #{post_tenant_response_json["TenantID"]}, #{self.rent_manager_id}"
      end
    else 
      p "Cannot sync stylist with Rent Manager because location doesn't have both rent_manager_property_id && rent_manager_location_id set."
    end
  end

  private

  def url_name_uniqueness
    if self.url_name
      @stylist = Stylist.find_by(:url_name => self.url_name) || Stylist.find_by(:url_name => self.url_name.split('_').join('-'))
      @location = Location.find_by(:url_name => self.url_name) || Location.find_by(:url_name => self.url_name.split('_').join('-'))

      if (@stylist && @stylist.id != self.id) || @location
        errors[:base] << 'This URL name is already in use. Please enter a unique name and try again'
      end
    end
  end

  def remove_from_mailchimp
    if self.email_address && self.email_address.present?
      gb = Gibbon::API.new('ddd6d7e431d3f8613c909e741cbcc948-us5')
      gb.lists.unsubscribe(:id => 'e5443d78c6', :email => {:email => self.email_address}, :delete_member => true, :send_goodbye => false, :send_notify => false)
     
      if self.location.mailchimp_list_ids && self.location.mailchimp_list_ids.present?
        admin = self.location.admin
        if admin && admin.mailchimp_api_key && admin.mailchimp_api_key.present?
          gb = Gibbon::API.new(admin.mailchimp_api_key)
          list_ids = self.location.mailchimp_list_ids.split(',').collect(&:strip)
          list_ids.each do |list_id|
            gb.lists.unsubscribe(:id => list_id, :email => {:email => self.email_address}, :delete_member => true, :send_goodbye => false, :send_notify => false)
          end
        end
      end
    end
  rescue => e
    # shh...
    p "error removing from mailchimp! #{e}"
  end

  def remove_from_mailchimp_if_closed
    remove_from_mailchimp if self.status && self.status == 'closed'
  end 

  def touch_stylist
    Stylist.all.first.touch
  end

  def generate_url_name
    if self.name && self.url_name.blank?
      url = self.name.downcase.gsub(/[^0-9a-zA-Z]/, '-') 
      count = 1
      
      while Stylist.where(:url_name => "#{url}#{count}").size > 0 do
        count = count + 1
      end

      self.url_name = "#{url}#{count}"
    end
  end

end