class Stylist < ActiveRecord::Base

  has_paper_trail
  
  scope :open, -> { where(:status => 'open') }

  belongs_to :location
  before_save :update_computed_fields, :fix_url_name

  belongs_to :testimonial_1, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_1'
  belongs_to :testimonial_2, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_2'
  belongs_to :testimonial_3, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_3'
  belongs_to :testimonial_4, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_4'
  belongs_to :testimonial_5, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_5'
  belongs_to :testimonial_6, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_6'
  belongs_to :testimonial_7, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_7'
  belongs_to :testimonial_8, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_8'
  belongs_to :testimonial_9, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_9'
  belongs_to :testimonial_10, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_10'

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

  validates :name, :presence => true
  validates :url_name, :presence => true, :uniqueness => true

  # define rails_admin enums
  [:hair, :skin, :nails, :massage, :teeth_whitening, :hair_extensions, :eyelash_extensions, :makeup, :tanning, :waxing, :brows, :accepting_new_clients].each do |name|
    define_method "#{name}_enum" do
      [['Yes', true], ['No', false]]
    end
  end

  def status_enum
    [['Open', 'open'], ['Closed', 'closed']]
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

  def services 
    services = []

    services << 'Hair' if hair
    services << 'Skin' if skin
    services << 'Nails' if nails
    services << 'Massage' if massage
    services << 'Teeth Whitening' if teeth_whitening
    services << 'Hair Extensions' if hair_extensions
    services << 'Eyelash Extensions' if eyelash_extensions
    services << 'Makeup' if makeup
    services << 'Tanning' if tanning
    services << 'Waxing' if waxing
    services << 'Brows' if brows

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

  private

  def update_computed_fields
    self.location_name = location.name if location && location.name
  end

  def fix_url_name
    self.url_name = self.url_name.gsub(/\./, '') if self.url_name.present?
  end

end