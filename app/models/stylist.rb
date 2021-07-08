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

  scope :open, -> { where(status: 'open') }
  scope :active, -> { open }
  scope :inactive, -> { where(status: 'closed') }

  scope :not_reserved, -> { where(:reserved => false) }

  after_initialize do
    if new_record?
      self.status ||= 'open'
      self.send_a_message_button ||= true
      self.phone_number_display ||= true
    end
  end

  before_validation :generate_url_name, :on => :create
  belongs_to :location
  before_save :update_computed_fields, :fix_url_name
  after_save :remove_from_mailchimp_if_closed, :sync_with_ping_hd, :sync_with_tru_digital#, :sync_with_rent_manager
  after_commit :sync_with_hubspot
  #after_create :sync_with_rent_manager
  after_create :send_welcome_email
  before_destroy :remove_from_ping_hd, :inactivate_with_hubspot
  after_destroy :remove_from_mailchimp, :touch_stylist, :create_terminated_stylist

  #has_one :studio
  has_many :leases, -> { order 'created_at desc' }
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

  has_attached_file :image_1, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_1, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_1
  before_validation { self.image_1.destroy if self.delete_image_1 == '1' }

  has_attached_file :image_2, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_2, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_2
  before_validation { self.image_2.destroy if self.delete_image_2 == '1' }

  has_attached_file :image_3, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_3, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_3
  before_validation { self.image_3.destroy if self.delete_image_3 == '1' }

  has_attached_file :image_4, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_4, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_4
  before_validation { self.image_4.destroy if self.delete_image_4 == '1' }

  has_attached_file :image_5, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_5, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_5
  before_validation { self.image_5.destroy if self.delete_image_5 == '1' }

  has_attached_file :image_6, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_6, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_6
  before_validation { self.image_6.destroy if self.delete_image_6 == '1' }

  has_attached_file :image_7, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_7, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_7
  before_validation { self.image_7.destroy if self.delete_image_7 == '1' }

  has_attached_file :image_8, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_8, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_8
  before_validation { self.image_8.destroy if self.delete_image_8 == '1' }

  has_attached_file :image_9, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_9, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_9
  before_validation { self.image_9.destroy if self.delete_image_9 == '1' }

  has_attached_file :image_10, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :carousel => '630x>' }, processors: [:thumbnail, :compression], :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_10, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_10
  before_validation { self.image_10.destroy if self.delete_image_10 == '1' }

  validates :email_address, :presence => true
  validates :email_address, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, :reduce => true#, :allow_blank => true, :on => :create
  #validates :email_address, :uniqueness => true, if: 'email_address.present?'

  validates :name, :url_name, :location, :presence => true
  validates :status, presence: true
  #validates :other_service, length: {maximum: 18}, allow_blank: true
  validate :url_name_uniqueness
  validates :url_name, :uniqueness => true, :reduce => true

  # TMP solution
  def new_status
    case status
    when 'open'
      'active'
    when 'closed'
      'inactive'
    else
      status
    end
  end

  def first_name
    FullNameSplitter.split(name)[0]
  end

  def last_name
    FullNameSplitter.split(name)[1]
  end

  def biography
    ActionView::Base.full_sanitizer.sanitize(self.read_attribute(:biography).to_s).squish
  end

  def country
    c = self.location ? Country.find_by(:code => self.location.country) : nil
    return c.name if c
    return nil
  end

  def social_links_present?
    facebook_url.present? || pinterest_url.present? || twitter_url.present? || instagram_url.present? || linkedin_url.present? || yelp_url.present? || google_plus_url.present?
  end

  def status_enum
    [['Active', 'open'], ['Inactive', 'closed']]
  end

  def send_a_message_button_enum
    [['Visible', true], ['Hidden', false]]
  end

  def reserved_enum
    [['Yes', true], ['No', false]]
  end

  def phone_number_display_enum
    [['Visible', true], ['Hidden', false]]
  end

  def sola_genius_enabled_enum
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
    services << 'Botox/Fillers' if botox
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

  def location_city
    return location.city if location
  end

  def location_state
    return location.state if location
  end

  def update_computed_fields
    self.location_name = location.name if location && location.name
    if location && location.msa
      self.msa_name = location.msa.name
    end
  end

  def has_sola_pro_login
    self.encrypted_password.present? || self.sola_pro_version.present? || self.sola_pro_platform.present?
  end

  # TODO replace this bullshit with friendly_id.
  def fix_url_name
    if self.url_name.present?
      self.url_name = self.url_name
                          .downcase
                          .gsub(/\s+/,'_')
                          .gsub(/[^0-9a-zA-Z]/, '_')
                          .gsub('___', '_')
                          .gsub('_-_', '_')
                          .gsub('_', '-')
    end
  end

  def sola_pro_start_date
    versions.order(:created_at => :desc).each do |version|
      reified_version = version.reify
      if reified_version && reified_version.encrypted_password.present?
        return version.created_at.to_date
      end
    end
    return nil
  end

  def canonical_path
    "/salon-professional/#{url_name}"
  end

  def canonical_url
    "https://www.solasalonstudios.#{location && location.country == 'CA' ? 'ca' : 'com'}/salon-professional/#{url_name}"
  end

  def has_sola_genius_account
    booking_url.to_s.include?('glossgenius.com')
  end

  def lease
    if self.leases && self.leases.size > 0
      lease = self.leases.first
      return lease# if lease.agreement_file_url.blank?
    end

    nil
  end

  def leases_at_location
    return self.location.leases.size if self.location && self.location.leases
  end

  def studios_at_location
    return self.location.studios.size if self.location && self.location.studios
  end

  def remove_from_ping_hd
    self.status = 'closed'
    self.sync_with_ping_hd
  end

  def inactivate_with_hubspot
    ::Hubspot::StylistJob.new.perform(self.id, 'inactivate')
  end

  def sync_with_hubspot
    ::Hubspot::StylistJob.perform_async(self.id, 'sync')
  end

  def sync_with_tru_digital
    data = []
    self.location.stylists.not_reserved.each do |stylist|
      data << {
        id: stylist.id,
        name: stylist.name,
        studio_number: stylist.studio_number,
        walkins: stylist.walkins
      }
    end

    p "curl -d 'location=#{self.location_id}' -d 'data=#{data.to_json}' 'https://app.trudigital.net/core/sola'"
    sync_with_tru_digital_response = `curl -d 'location=#{self.location_id}' -d 'data=#{data.length == 0 ? [nil].to_json : data.to_json}' 'https://app.trudigital.net/core/sola'`

    p "sync_with_tru_digital_response=#{sync_with_tru_digital_response.inspect}"
  rescue => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
  end

  def sync_with_ping_hd
    return true if self.reserved
    url = "https://go.engagephd.com/Sola.aspx"
    p "url=#{url}"

    payload = {
      accessCode: "1315-TFp", #"138-Xfd",
      location: self.location_id,
      productNumber: self.id,
      category: self.services.join(', '),
      subCategory: self.business_name,
      name: self.name,
      #description: self.biography,
      room: self.studio_number,
      enabled: self.status && self.status == 'closed' ? false : true,
      walkins: self.walkins
    }

    p "payload=#{payload.inspect}"

    sync_with_ping_hd_response = RestClient::Request.execute({
      #:headers => {"Content-Type" => "application/json"},
      :method => :post,
      #:content_type => 'application/json',
      :url => url,
      :payload => payload
    })

    p "sync_with_ping_hd_response=#{sync_with_ping_hd_response.inspect}"
  rescue => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
  end

  def sync_with_rent_manager
    if location && location.rent_manager_property_id.present? && location.rent_manager_location_id.present?
      require 'rest-client'
      p "Sync stylist with Rent Manager: rent_manager_property_id=#{location.rent_manager_property_id}, rent_manager_location_id=#{location.rent_manager_location_id}"

      payload = {
        "FirstName" => self.first_name,
        "LastName" => self.last_name,
        "PropertyID" => self.location.rent_manager_property_id
      }

      payload["TenantID"] = self.rent_manager_id if self.rent_manager_id.present?

      if self.email_address.present?
        payload["PrimaryContact"] = {
          "FirstName" => self.first_name,
          "LastName" => self.last_name,
          "Email" => self.email_address,
        }
      end

      p "payload=#{payload}"
      p "url=https://solasalon.apiservices.rentmanager.com/api/#{location.rent_manager_location_id}/tenants"

      post_tenant_response = RestClient::Request.execute({
        :headers => {"Content-Type" => "application/json"},
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
  rescue => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
    p "error sync_with_rent_manager #{e}"
  end

  def image_1_url
    image_1.url(:carousel) if image_1.present?
  end

  def image_2_url
    image_2.url(:carousel) if image_2.present?
  end

  def image_3_url
    image_3.url(:carousel) if image_3.present?
  end

  def image_4_url
    image_4.url(:carousel) if image_4.present?
  end

  def image_5_url
    image_5.url(:carousel) if image_5.present?
  end

  def image_6_url
    image_6.url(:carousel) if image_6.present?
  end

  def image_7_url
    image_7.url(:carousel) if image_7.present?
  end

  def image_8_url
    image_8.url(:carousel) if image_8.present?
  end

  def image_9_url
    image_9.url(:carousel) if image_9.present?
  end

  def image_10_url
    image_10.url(:carousel) if image_10.present?
  end

  def send_welcome_email
    if location && location.country && location.country == 'US'
      PublicWebsiteMailer.welcome_email_us(self).deliver
    elsif location && location.country && location.country == 'CA'
      PublicWebsiteMailer.welcome_email_ca(self).deliver
    end
    ::Stylists::ResendWelcomeEmailJob.perform_in(1.week, self.id)
  rescue => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
  end

  def resend_welcome_email
    if location && location.country && location.country == 'US'
      PublicWebsiteMailer.welcome_email_us(self, true).deliver
    elsif location && location.country && location.country == 'CA'
      PublicWebsiteMailer.welcome_email_ca(self, true).deliver
    end
  rescue => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
  end

  def as_json(options={})
    super(:methods => [:leases, :location, :testimonial_1, :testimonial_2, :testimonial_3, :testimonial_4, :testimonial_5, :testimonial_6, :testimonial_7, :testimonial_8, :testimonial_9, :testimonial_10,
                       :image_1_url, :image_2_url, :image_3_url, :image_4_url, :image_5_url, :image_6_url, :image_7_url, :image_8_url, :image_9_url, :image_10_url])
  end

  private

  def url_name_uniqueness
    if self.url_name
      @stylist = Stylist.find_by(:url_name => self.url_name) || Stylist.find_by(:url_name => self.url_name.split('_').join('-'))
      @location = Location.find_by(:url_name => self.url_name) || Location.find_by(:url_name => self.url_name.split('_').join('-'))

      if (@stylist && @stylist.id != self.id) || @location
        errors[:url_name] << 'already in use by another salon professional. Please enter a unique URL name and try again'
      end
    end
  end

  def create_terminated_stylist
    TerminatedStylist.create({
      location_id: self.location_id,
      stylist_created_at: self.created_at,
      name: self.name,
      email_address: self.email_address,
      phone_number: self.phone_number,
      studio_number: self.studio_number,
    })
  end

  def remove_from_mailchimp
    if self.email_address && self.email_address.present?
      #gb = Gibbon::API.new('ddd6d7e431d3f8613c909e741cbcc948-us5')
      #gb.lists.unsubscribe(:id => 'e5443d78c6', :email => {:email => self.email_address}, :delete_member => true, :send_goodbye => false, :send_notify => false)

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
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
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

# == Schema Information
#
# Table name: stylists
#
#  id                             :integer          not null, primary key
#  accepting_new_clients          :boolean          default(TRUE)
#  biography                      :text
#  booking_url                    :string(255)
#  botox                          :boolean
#  brows                          :boolean
#  business_name                  :string(255)
#  city                           :string(255)
#  cosmetology_license_date       :date
#  cosmetology_license_number     :string(255)
#  country                        :string(255)
#  current_sign_in_at             :datetime
#  current_sign_in_ip             :inet
#  date_of_birth                  :date
#  electronic_license_agreement   :boolean          default(FALSE)
#  email_address                  :citext           not null
#  emergency_contact_name         :string(255)
#  emergency_contact_phone_number :string(255)
#  emergency_contact_relationship :string(255)
#  encrypted_password             :string(255)      default("")
#  eyelash_extensions             :boolean
#  facebook_url                   :string(255)
#  force_show_book_now_button     :boolean          default(FALSE)
#  google_plus_url                :string(255)
#  hair                           :boolean
#  hair_extensions                :boolean
#  image_10_alt_text              :text
#  image_10_content_type          :string(255)
#  image_10_file_name             :string(255)
#  image_10_file_size             :integer
#  image_10_updated_at            :datetime
#  image_1_alt_text               :text
#  image_1_content_type           :string(255)
#  image_1_file_name              :string(255)
#  image_1_file_size              :integer
#  image_1_updated_at             :datetime
#  image_2_alt_text               :text
#  image_2_content_type           :string(255)
#  image_2_file_name              :string(255)
#  image_2_file_size              :integer
#  image_2_updated_at             :datetime
#  image_3_alt_text               :text
#  image_3_content_type           :string(255)
#  image_3_file_name              :string(255)
#  image_3_file_size              :integer
#  image_3_updated_at             :datetime
#  image_4_alt_text               :text
#  image_4_content_type           :string(255)
#  image_4_file_name              :string(255)
#  image_4_file_size              :integer
#  image_4_updated_at             :datetime
#  image_5_alt_text               :text
#  image_5_content_type           :string(255)
#  image_5_file_name              :string(255)
#  image_5_file_size              :integer
#  image_5_updated_at             :datetime
#  image_6_alt_text               :text
#  image_6_content_type           :string(255)
#  image_6_file_name              :string(255)
#  image_6_file_size              :integer
#  image_6_updated_at             :datetime
#  image_7_alt_text               :text
#  image_7_content_type           :string(255)
#  image_7_file_name              :string(255)
#  image_7_file_size              :integer
#  image_7_updated_at             :datetime
#  image_8_alt_text               :text
#  image_8_content_type           :string(255)
#  image_8_file_name              :string(255)
#  image_8_file_size              :integer
#  image_8_updated_at             :datetime
#  image_9_alt_text               :text
#  image_9_content_type           :string(255)
#  image_9_file_name              :string(255)
#  image_9_file_size              :integer
#  image_9_updated_at             :datetime
#  instagram_url                  :string(255)
#  laser_hair_removal             :boolean
#  last_sign_in_at                :datetime
#  last_sign_in_ip                :inet
#  linkedin_url                   :string(255)
#  location_name                  :string(255)
#  makeup                         :boolean
#  massage                        :boolean
#  microblading                   :boolean
#  msa_name                       :string(255)
#  nails                          :boolean
#  name                           :string(255)
#  onboarded                      :boolean          default(FALSE), not null
#  other_service                  :string(255)
#  permanent_makeup               :boolean
#  permitted_use_for_studio       :string(255)
#  phone_number                   :string(255)
#  phone_number_display           :boolean          default(TRUE)
#  pinterest_url                  :string(255)
#  postal_code                    :string(255)
#  remember_created_at            :datetime
#  reserved                       :boolean          default(FALSE)
#  reset_password_sent_at         :datetime
#  reset_password_token           :string(255)
#  send_a_message_button          :boolean          default(TRUE)
#  sg_booking_url                 :string(255)
#  sign_in_count                  :integer          default(0), not null
#  skin                           :boolean
#  sola_genius_enabled            :boolean          default(TRUE)
#  sola_pro_platform              :string(255)
#  sola_pro_version               :string(255)
#  solagenius_account_created_at  :datetime
#  state_province                 :string(255)
#  status                         :string(255)
#  street_address                 :string(255)
#  studio_number                  :string(255)
#  tanning                        :boolean
#  teeth_whitening                :boolean
#  testimonial_id_1               :integer
#  testimonial_id_10              :integer
#  testimonial_id_2               :integer
#  testimonial_id_3               :integer
#  testimonial_id_4               :integer
#  testimonial_id_5               :integer
#  testimonial_id_6               :integer
#  testimonial_id_7               :integer
#  testimonial_id_8               :integer
#  testimonial_id_9               :integer
#  threading                      :boolean
#  total_booknow_bookings         :integer
#  total_booknow_revenue          :string(255)
#  twitter_url                    :string(255)
#  url_name                       :string(255)
#  walkins                        :boolean
#  walkins_expiry                 :datetime
#  waxing                         :boolean
#  website_email_address          :string(255)
#  website_go_live_date           :date             default(Thu, 01 Jan 2004)
#  website_name                   :string(255)
#  website_phone_number           :string(255)
#  website_url                    :string(255)
#  work_hours                     :text
#  yelp_url                       :string(255)
#  created_at                     :datetime
#  updated_at                     :datetime
#  legacy_id                      :string(255)
#  location_id                    :integer
#  rent_manager_contact_id        :string(255)
#  rent_manager_id                :string(255)
#
# Indexes
#
#  index_stylists_on_email_address           (email_address)
#  index_stylists_on_location_id             (location_id)
#  index_stylists_on_location_id_and_status  (location_id,status)
#  index_stylists_on_reset_password_token    (reset_password_token) UNIQUE
#  index_stylists_on_status                  (status)
#  index_stylists_on_url_name                (url_name)
#
