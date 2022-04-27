# frozen_string_literal: true

class Article < ActiveRecord::Base
  belongs_to :location

  before_save :fix_url_name
  before_create :generate_url_name
  validates :title, presence: true
  validates :article_url, presence: true
  validates :location, presence: true, if: :franchisee?
  # validates :url_name, :presence => true, :uniqueness => true

  has_attached_file :image, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { full_width: '960#', directory: '375x375#', thumbnail: '100x100#' }, s3_protocol: :https
  validates_attachment_content_type :image, content_type: %r{\Aimage/.*\Z}
  validates_attachment_presence :image
  attr_accessor :delete_image

  before_validation { image.destroy if delete_image == '1' }

  has_paper_trail

  def to_param
    url_name
  end

  def safe_title
    EscapeUtils.escape_url(title.gsub(/&#8211;/, '-'))
  end

  def display_setting_enum
    [['Sola Website', 'sola_website'], ['Franchising Website', 'franchising'], %w[Both both]]
  end

  private

    def generate_url_name
      if title
        url = title.downcase.gsub(/[^0-9a-zA-Z]/, '_')
        count = 1

        while Blog.where(url_name: url).size.positive?
          url = "#{url}#{count}"
          count += 1
        end

        self.url_name = url
      end
    end

    def fix_url_name
      self.url_name = url_name.gsub(/[^0-9a-zA-Z]/, '_') if url_name.present?
    end

    def franchisee?
      Thread.current[:current_admin]&.franchisee
    end
end

# == Schema Information
#
# Table name: articles
#
#  id                 :integer          not null, primary key
#  article_url        :text
#  body               :text
#  display_setting    :string(255)      default("sola_website")
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  summary            :text
#  title              :string(255)
#  url_name           :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  legacy_id          :string(255)
#  location_id        :integer
#
# Indexes
#
#  index_articles_on_location_id  (location_id)
#  index_articles_on_url_name     (url_name)
#
