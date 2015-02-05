class Stylist < ActiveRecord::Base

  belongs_to :location

  validates :name, :presence => true
  validates :url_name, :presence => true, :uniqueness => true

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

end
