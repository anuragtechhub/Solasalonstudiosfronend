class Location < ActiveRecord::Base

  has_paper_trail

  scope :open, -> { where(:status => 'open') }

  belongs_to :admin
  belongs_to :msa
  has_many :stylists, -> { where(:status => 'open') }

  before_create :generate_url_name
  before_save :fix_url_name
  after_validation :geocode
  geocoded_by :full_address
  after_destroy :touch_location

  after_initialize do
    if new_record?
      self.status ||= 'open'
    end
  end

  has_attached_file :floorplan_image, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' }   
  validates_attachment_content_type :floorplan_image, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_floorplan_image
  before_validation { self.floorplan_image.destroy if self.delete_floorplan_image == '1' }

  has_attached_file :image_1, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_1, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_1
  before_validation { self.image_1.destroy if self.delete_image_1 == '1' }

  has_attached_file :image_2, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_2, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_2
  before_validation { self.image_2.destroy if self.delete_image_2 == '1' }

  has_attached_file :image_3, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_3, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_3
  before_validation { self.image_3.destroy if self.delete_image_3 == '1' }

  has_attached_file :image_4, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_4, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_4
  before_validation { self.image_4.destroy if self.delete_image_4 == '1' }

  has_attached_file :image_5, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_5, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_5
  before_validation { self.image_5.destroy if self.delete_image_5 == '1' }

  has_attached_file :image_6, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_6, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_6
  before_validation { self.image_6.destroy if self.delete_image_6 == '1' }

  has_attached_file :image_7, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_7, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_7
  before_validation { self.image_7.destroy if self.delete_image_7 == '1' }

  has_attached_file :image_8, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_8, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_8
  before_validation { self.image_8.destroy if self.delete_image_8 == '1' }

  has_attached_file :image_9, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_9, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_9
  before_validation { self.image_9.destroy if self.delete_image_9 == '1' }

  has_attached_file :image_10, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_10, :content_type => /\Aimage\/.*\Z/              
  attr_accessor :delete_image_10
  before_validation { self.image_10.destroy if self.delete_image_10 == '1' }

  has_attached_file :image_11, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_11, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_11
  before_validation { self.image_11.destroy if self.delete_image_11 == '1' }

  has_attached_file :image_12, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_12, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_12
  before_validation { self.image_12.destroy if self.delete_image_12 == '1' }

  has_attached_file :image_13, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_13, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_13
  before_validation { self.image_13.destroy if self.delete_image_13 == '1' }

  has_attached_file :image_14, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_14, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_14
  before_validation { self.image_14.destroy if self.delete_image_14 == '1' }

  has_attached_file :image_15, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_15, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_15
  before_validation { self.image_15.destroy if self.delete_image_15 == '1' }

  has_attached_file :image_16, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_16, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_16
  before_validation { self.image_16.destroy if self.delete_image_16 == '1' }

  has_attached_file :image_17, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_17, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_17
  before_validation { self.image_17.destroy if self.delete_image_17 == '1' }

  has_attached_file :image_18, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_18, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_18
  before_validation { self.image_18.destroy if self.delete_image_18 == '1' }

  has_attached_file :image_19, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_19, :content_type => /\Aimage\/.*\Z/       
  attr_accessor :delete_image_19
  before_validation { self.image_19.destroy if self.delete_image_19 == '1' }

  has_attached_file :image_20, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :image_20, :content_type => /\Aimage\/.*\Z/                         
  attr_accessor :delete_image_20
  before_validation { self.image_20.destroy if self.delete_image_20 == '1' }

  # directory images below...

  has_attached_file :directory_image_1, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :directory_image_1, :content_type => /\Aimage\/.*\Z/                         
  attr_accessor :delete_directory_image_1
  before_validation { self.directory_image_1.destroy if self.delete_directory_image_1 == '1' }

  has_attached_file :directory_image_2, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :directory_image_2, :content_type => /\Aimage\/.*\Z/                         
  attr_accessor :delete_directory_image_2
  before_validation { self.directory_image_2.destroy if self.delete_directory_image_2 == '1' }

  has_attached_file :directory_image_3, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :directory_image_3, :content_type => /\Aimage\/.*\Z/                         
  attr_accessor :delete_directory_image_3
  before_validation { self.directory_image_3.destroy if self.delete_directory_image_3 == '1' }

  has_attached_file :directory_image_4, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :directory_image_4, :content_type => /\Aimage\/.*\Z/                         
  attr_accessor :delete_directory_image_4
  before_validation { self.directory_image_4.destroy if self.delete_directory_image_4 == '1' }

  has_attached_file :directory_image_5, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :directory_image_5, :content_type => /\Aimage\/.*\Z/                         
  attr_accessor :delete_directory_image_5
  before_validation { self.directory_image_5.destroy if self.delete_directory_image_5 == '1' }

  has_attached_file :directory_image_6, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :directory_image_6, :content_type => /\Aimage\/.*\Z/                         
  attr_accessor :delete_directory_image_6
  before_validation { self.directory_image_6.destroy if self.delete_directory_image_6 == '1' }

  has_attached_file :directory_image_7, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :directory_image_7, :content_type => /\Aimage\/.*\Z/                         
  attr_accessor :delete_directory_image_7
  before_validation { self.directory_image_7.destroy if self.delete_directory_image_7 == '1' }

  has_attached_file :directory_image_8, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :directory_image_8, :content_type => /\Aimage\/.*\Z/                         
  attr_accessor :delete_directory_image_8
  before_validation { self.directory_image_8.destroy if self.delete_directory_image_8 == '1' }

  has_attached_file :directory_image_9, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :directory_image_9, :content_type => /\Aimage\/.*\Z/                         
  attr_accessor :delete_directory_image_9
  before_validation { self.directory_image_9.destroy if self.delete_directory_image_9 == '1' }

  has_attached_file :directory_image_10, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :directory_image_10, :content_type => /\Aimage\/.*\Z/                         
  attr_accessor :delete_directory_image_10
  before_validation { self.directory_image_10.destroy if self.delete_directory_image_10 == '1' }

  has_attached_file :directory_image_11, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :directory_image_11, :content_type => /\Aimage\/.*\Z/                         
  attr_accessor :delete_directory_image_11
  before_validation { self.directory_image_11.destroy if self.delete_directory_image_11 == '1' }

  has_attached_file :directory_image_12, :styles => { :carousel => '625x>', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}, :convert_options => { :all => '-auto-orient' } 
  validates_attachment_content_type :directory_image_12, :content_type => /\Aimage\/.*\Z/                         
  attr_accessor :delete_directory_image_12
  before_validation { self.directory_image_12.destroy if self.delete_directory_image_12 == '1' }                    

  validates :name, :presence => true
  #validates :url_name, :presence => true, :uniqueness => true

  def msa_name
    msa ? msa.name : ''
  end

  def services
    services = []

    stylists.each do |stylist|
      services = services + stylist.services
    end

    services.uniq.sort
  end

  def status_enum
    [['Open', 'open'], ['Closed', 'closed']]
  end

  def html_address
    address = ''

    address += address_1 if address_1.present?
    address += ' ' + address_2 if address_2.present?
    address += '<br>'
    address += "#{city}, #{state} #{postal_code}"

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

  def social_links_present?
    facebook_url.present? || pinterest_url.present? || twitter_url.present? || instagram_url.present? || yelp_url.present?
  end

  def display_name
    "#{name} (#{city}, #{state})"
  end

  def as_json(options={})
    super(:except => [:created_at, :updated_at])
  end

  private

  def to_param
    "#{state}/#{city}/#{url_name}"
  end

  def touch_location
    Location.all.first.touch
  end

  def generate_url_name
    if self.name
      url = self.name.downcase.gsub(/[^0-9a-zA-Z]/, '_') 
      count = 1
      
      while Location.where(:url_name => url).size > 0 do
        url = "#{url}#{count}"
        count = count + 1
      end

      self.url_name = url
    end
  end

  def fix_url_name
    self.url_name = self.url_name.gsub(/[^0-9a-zA-Z]/, '_') if self.url_name.present?
  end

end