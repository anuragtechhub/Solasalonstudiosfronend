class MySolaImage < ActiveRecord::Base

  include Publically

  before_save :set_approved_at, :if => :was_just_approved

  has_attached_file :image, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image
  before_validation { self.image.destroy if self.delete_image == '1' }

  def approved_enum
    [['Yes', true], ['No', false]]
  end

  def as_json(options={})
    super(:methods => [:original_image_url, :share_url]).merge(options)
  end

  def original_image_url
    image.url(:original) if image.present?
  end

  def share_url
    "http://solasalons.com/mysola/#{public_id}"
  end

  def statement_text
    if statement_variant == 'mysola_is'
      "#MySola is my #{statement}"
    elsif statement_variant == 'i_feel'
      "I feel #{statement} in #MySola"
    end
  end

  def statement_variant_enum
    [['#MySola is my [BLANK]', 'mysola_is'], ['I feel [BLANK] in #MySola', 'i_feel']]
  end

  private

  def set_approved_at
    approved_at = DateTime.now
  end

  def was_just_approved
    approved == true && approved_was == false
  end

end