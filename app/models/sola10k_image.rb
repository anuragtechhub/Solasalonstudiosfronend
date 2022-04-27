# frozen_string_literal: true

class Sola10kImage < ActiveRecord::Base
  has_paper_trail

  include Publically

  scope :completed, -> { where("statement <> '' AND image_file_name IS NOT NULL AND generated_image_file_name IS NOT NULL AND(name IS NOT NULL OR instagram_handle IS NOT NULL)") }

  before_save :set_approved_at, if: :was_just_approved

  has_attached_file :image, styles: { original: '1080x>' }, source_file_options: { all: '-auto-orient' }
  validates_attachment_content_type :image, content_type: %r{\Aimage/.*\Z}
  attr_accessor :delete_image, :delete_generated_image

  before_validation { image.destroy if delete_image == '1' }

  has_attached_file :generated_image, styles: { funsize: '540x>', share: '400x>' }, source_file_options: { all: '-auto-orient' }
  validates_attachment_content_type :generated_image, content_type: %r{\Aimage/.*\Z}

  before_validation { generated_image.destroy if delete_generated_image == '1' }

  def approved_enum
    [['Yes', true], ['No', false]]
  end

  def as_json(options = {})
    super(methods: %i[generated_image_url original_image_url share_url],
          except:  %i[created_at updated_at approved approved_at
                      generated_image_file_name generated_image_content_type generated_image_file_size generated_image_updated_at
                      image_file_name image_content_type image_file_size image_updated_at statement statement_variant]).merge(options)
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
    statement
    # if statement_variant == 'mysola_is'
    #   "#MySola is my #{statement}"
    # elsif statement_variant == 'i_feel'
    #   "I feel #{statement} in #MySola"
    # end
  end

  def statement_variant_enum
    [%w[My my]]
  end

  private

    def set_approved_at
      approved_at = DateTime.now
    end

    def was_just_approved
      approved == true && approved_was == false
    end
end

# == Schema Information
#
# Table name: sola10k_images
#
#  id                           :integer          not null, primary key
#  approved                     :boolean
#  approved_at                  :datetime
#  color                        :string(255)
#  generated_image_content_type :string(255)
#  generated_image_file_name    :string(255)
#  generated_image_file_size    :integer
#  generated_image_updated_at   :datetime
#  image_content_type           :string(255)
#  image_file_name              :string(255)
#  image_file_size              :integer
#  image_updated_at             :datetime
#  instagram_handle             :string(255)
#  name                         :string(255)
#  statement                    :text
#  created_at                   :datetime
#  updated_at                   :datetime
#  public_id                    :string(255)
#
