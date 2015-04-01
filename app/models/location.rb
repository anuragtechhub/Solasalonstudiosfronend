class Location < ActiveRecord::Base

  scope :open, -> { where(:status => 'open') }

  has_many :stylists

  after_validation :geocode
  geocoded_by :full_address

  has_attached_file :floorplan_image, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :floorplan_image, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_1, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_1, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_2, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_2, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_3, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_3, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_4, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_4, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_5, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_5, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_6, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_6, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_7, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_7, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_8, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_8, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_9, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_9, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image_10, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_10, :content_type => /\Aimage\/.*\Z/              

  has_attached_file :image_11, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_11, :content_type => /\Aimage\/.*\Z/       

  has_attached_file :image_12, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_12, :content_type => /\Aimage\/.*\Z/       

  has_attached_file :image_13, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_13, :content_type => /\Aimage\/.*\Z/       

  has_attached_file :image_14, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_14, :content_type => /\Aimage\/.*\Z/       

  has_attached_file :image_15, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_15, :content_type => /\Aimage\/.*\Z/       

  has_attached_file :image_16, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_16, :content_type => /\Aimage\/.*\Z/       

  has_attached_file :image_17, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_17, :content_type => /\Aimage\/.*\Z/       

  has_attached_file :image_18, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_18, :content_type => /\Aimage\/.*\Z/       

  has_attached_file :image_19, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_19, :content_type => /\Aimage\/.*\Z/       

  has_attached_file :image_20, :styles => { :directory => '375x375#', :thumbnail => '100x100#' }
  validates_attachment_content_type :image_20, :content_type => /\Aimage\/.*\Z/                         

  validates :name, :presence => true
  validates :url_name, :presence => true, :uniqueness => true

  def status_enum
    [['Open', 'open'], ['Closed', 'closed']]
  end

  def html_address
    address = ''

    address += address_1 if address_1.present?
    address += ' ' + address_2 if address_2.present?
    address += '<br>'
    address += "#{city}, #{state} #{postal_code}"

    return address.html_safe
  end

  def full_address
    "#{address_1} #{address_2} #{city}, #{state} #{postal_code}"
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

  def to_param
    "#{state}/#{city}/#{url_name}"
  end

end