class Stylist < ActiveRecord::Base

  belongs_to :location
  before_save :update_computed_fields

  validates :name, :presence => true
  validates :url_name, :presence => true, :uniqueness => true

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

  # define rails_admin enums
  [:hair, :skin, :nails, :massage, :teeth_whitening, :eyelash_extensions, :makeup, :tanning, :waxing, :brows, :accepting_new_clients].each do |name|
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

  # helper function to return testimonials as array
  def testimonials
    testimonial_array = []
    (1..10).each do |num|
      testimonial = self.send("testimonial_#{num}")
      testimonial_array << testimonial if testimonial.present?
    end
    testimonial_array
  end

  private

  def update_computed_fields
    self.location_name = location.name if location
  end

end
