# frozen_string_literal: true

class MySolaImage < ActiveRecord::Base
  include PgSearch::Model
  pg_search_scope :search_by_name_and_status, against: [:name, :instagram_handle, :approved],
  using: {
    tsearch: {
      prefix: true,
      any_word: true
    }
  }
  has_paper_trail

  include Publically

  scope :completed, -> { where("statement <> '' AND statement_variant IS NOT NULL AND image_file_name IS NOT NULL AND generated_image_file_name IS NOT NULL AND(name IS NOT NULL OR instagram_handle IS NOT NULL)") }

  before_save :set_approved_at, if: :was_just_approved

  has_attached_file :image, styles: { original: '1080x>' }, source_file_options: { all: '-auto-orient' }, s3_protocol: :https
  validates_attachment_content_type :image, content_type: %r{\Aimage/.*\Z}
  attr_accessor :delete_image, :delete_generated_image

  before_validation { image.destroy if delete_image == '1' }

  has_attached_file :generated_image, styles: { funsize: '400x>' }, source_file_options: { all: '-auto-orient' }, s3_protocol: :https
  validates_attachment_content_type :generated_image, content_type: %r{\Aimage/.*\Z}

  before_validation { generated_image.destroy if delete_generated_image == '1' }

  def approved_enum
    [['Yes', true], ['No', false]]
  end

  def as_json(options = {})
    super(methods: %i[generated_image_url original_image_url share_url],
          except:  %i[created_at updated_at  approved_at
                      generated_image_file_name generated_image_content_type generated_image_file_size generated_image_updated_at
                      image_file_name image_content_type image_file_size image_updated_at  ])
  end

  def generated_image_url
    generated_image.url(:original).gsub('http://', 'https://') if generated_image.present?
  end

  def original_image_url
    image.url(:original) if image.present?
  end

  def share_url
    "http://solasalons.com/mysola/#{public_id}"
  end

  def statement_text
    case statement_variant
    when 'mysola_is'
      "#MySola is my #{statement}"
    when 'i_feel'
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

# == Schema Information
#
# Table name: my_sola_images
#
#  id                           :integer          not null, primary key
#  approved                     :boolean          default(FALSE)
#  approved_at                  :datetime
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
#  statement_variant            :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  public_id                    :string(255)
#
