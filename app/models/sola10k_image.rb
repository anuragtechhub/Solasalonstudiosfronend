class Sola10kImage < ActiveRecord::Base

  has_paper_trail

  include Publically

  scope :completed, -> { where("statement <> '' AND statement_variant IS NOT NULL AND image_file_name IS NOT NULL AND generated_image_file_name IS NOT NULL AND(name IS NOT NULL OR instagram_handle IS NOT NULL)") }

  before_save :set_approved_at, :if => :was_just_approved

  has_attached_file :image, :styles => { :original => '1080x>' }, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image
  before_validation { self.image.destroy if self.delete_image == '1' }

  has_attached_file :generated_image, :styles => { :funsize => '400x>' }, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :generated_image, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_generated_image
  before_validation { self.generated_image.destroy if self.delete_generated_image == '1' }

  def approved_enum
    [['Yes', true], ['No', false]]
  end

  def as_json(options={})
    super(:methods => [:generated_image_url, :original_image_url, :share_url], 
			  	:except => [:created_at, :updated_at, :approved, :approved_at, 
			    :generated_image_file_name, :generated_image_content_type, :generated_image_file_size, :generated_image_updated_at, 
			    :image_file_name, :image_content_type, :image_file_size, :image_updated_at, :statement, :statement_variant]).merge(options)
  end

  def generated_image_url
    generated_image.url(:original).gsub('http://', 'https://') if generated_image.present?
  end

  def original_image_url
    image.url(:original) if image.present?
  end

  def share_url
    "http://solasalons.com/sola10k/#{public_id}"
  end

  def statement_text
  	return statement
    # if statement_variant == 'mysola_is'
    #   "#MySola is my #{statement}"
    # elsif statement_variant == 'i_feel'
    #   "I feel #{statement} in #MySola"
    # end
  end

  def statement_variant_enum
    [['My', 'my']]
  end

  private

  def set_approved_at
    approved_at = DateTime.now
  end

  def was_just_approved
    approved == true && approved_was == false
  end

end