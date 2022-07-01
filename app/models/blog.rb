# frozen_string_literal: true

class Blog < ActiveRecord::Base
  include PgSearch::Model

  pg_search_scope :search, against: [:title], associated_against: {
    categories: [:name],
  },using: {
      tsearch: {
        prefix: true
      }
    }

  before_save :fix_url_name, :https_images, :check_publish_date
  before_create :generate_url_name
  after_destroy :touch_blog

  has_many :blog_blog_categories
  has_many :blog_categories, through: :blog_blog_categories
  has_many :blog_countries
  has_many :countries, through: :blog_countries

  has_many :categoriables, as: :item, dependent: :destroy
  has_many :categories, through: :categoriables

  has_many :taggables, as: :item, dependent: :destroy
  has_many :tags, through: :taggables

  has_many :notifications, dependent: :destroy

  validates :title, :status, presence: true
  validates :countries, presence: true
  validates :url_name, presence: true, uniqueness: true

  has_attached_file :carousel_image, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { full_width: '960>', directory: '375x375#', thumbnail: '100x100#', carousel: '400x540#' }, s3_protocol: :https
  validates_attachment_content_type :carousel_image, content_type: %r{\Aimage/.*\Z}
  attr_accessor :delete_carousel_image, :delete_image

  before_validation { carousel_image.destroy if delete_carousel_image == '1' }

  has_attached_file :image, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { full_width: '960>', directory: '375x375#', thumbnail: '100x100#' }, s3_protocol: :https
  validates_attachment_content_type :image, content_type: %r{\Aimage/.*\Z}

  before_validation { image.destroy if delete_image == '1' }

  scope :published, -> { where(status: 'published') }
  scope :draft, -> { where(status: 'draft') }

  scope :by_country, lambda { |country|
    includes(:countries).where(countries: { code: country })
  }

  scope :by_category, lambda { |category_id|
    includes(:categories).where(categories: { id: category_id })
  }

  scope :search_by_query, lambda { |query|
    where('LOWER(title) LIKE :query OR LOWER(body) LIKE :query OR LOWER(author) LIKE :query', query: "%#{query.downcase.gsub(/\s/, '%')}%")
  }

  has_paper_trail

  def safe_title
    EscapeUtils.escape_url(title.gsub(/&#8211;/, '-'))
  end

  def related_blogs
    blogs = []

    if blog_categories.length.positive?
      blog_categories.each do |category|
        if category.blogs&.length&.positive?
          category.blogs.where(status: 'published').order(created_at: :desc).each do |blog|
            if blog.id != id && blogs.exclude?(blog)
              blogs << blog
              break if blogs.length == 3
            end
          end
        end
        break if blogs.length == 3
      end
    end

    if blogs.length < 3
      Blog.order(created_at: :desc).limit(5).each do |blog|
        if blog.id != id && blogs.exclude?(blog)
          blogs << blog
          break if blogs.length == 3
        end
      end
    end

    blogs
  end

  def contact_form_visible_enum
    [['Yes', true], ['No', false]]
  end

  def status_enum
    [%w[Published published], %w[Draft draft]]
  end

  def to_param
    url_name
  end

  # TODO: replace this bullshit with friendly_id.
  def fix_url_name
    if url_name.present?
      self.url_name = url_name
        .downcase
        .gsub(/\s+/, '_')
        .gsub(/[^0-9a-zA-Z]/, '_')
        .gsub('___', '_')
        .gsub('_-_', '_')
        .gsub('_', '-')
    end
  end

  def canonical_path
    "/blog/#{url_name}"
  end

  def get_canonical_url(locale = :en)
    canonical_url.presence || "https://www.solasalonstudios.#{locale == :en ? 'com' : 'ca'}/blog/#{url_name}"
  end

  def image_url
    image.url(:full_width).gsub('/solasalonstylists/', '/solasalonstudios/')
  end

  def carousel_image_url
    carousel_image.url(:full_width).gsub('/solasalonstylists/', '/solasalonstudios/')
  end 

  def url
    # "https://www.solaprofessional.com#{Rails.application.routes.url_helpers.show_blog_path(self)}?_ios=y&_hdr=n"
  end

    def as_json(_options = {})
      super(except: %i[image_file_name image_file_size image_content_type
                       image_updated_at carousel_image_file_name carousel_image_content_type carousel_image_file_size
                       carousel_image_updated_at legacy_id ], methods: %i[blog_blog_categories image_url url carousel_image_url ], include: %i[ countries tags blog_categories categories ])
    end

  private

    def generate_url_name
      if title
        url = title.downcase.gsub(/[^0-9a-zA-Z]/, '-')
        count = 1

        while Blog.where(url_name: url).size.positive?
          url = "#{url}#{count}"
          count += 1
        end

        self.url_name = url
      end
    end

    def touch_blog
      Blog.all.first.touch
    end

    def https_images
      if body
        self.body = body.gsub(/<img[^>]+>/) do |img|
          img.gsub(/src="http:/, 'src="https:')
        end
      end
    end

    def check_publish_date
      if publish_date && publish_date <= DateTime.now
        self.status = 'published'
      elsif publish_date && publish_date > DateTime.now
        self.status = 'draft'
      elsif status == 'published' && publish_date.nil?
        self.publish_date = created_at || DateTime.now
      else
        self.status = 'draft'
        self.publish_date = nil
      end
    end
end

# == Schema Information
#
# Table name: blogs
#
#  id                          :integer          not null, primary key
#  author                      :string(255)
#  body                        :text
#  canonical_url               :string(255)
#  carousel_image_content_type :string(255)
#  carousel_image_file_name    :string(255)
#  carousel_image_file_size    :integer
#  carousel_image_updated_at   :datetime
#  carousel_text               :string(255)
#  contact_form_visible        :boolean          default(FALSE)
#  fb_conversion_pixel         :text
#  image_content_type          :string(255)
#  image_file_name             :string(255)
#  image_file_size             :integer
#  image_updated_at            :datetime
#  meta_description            :text
#  publish_date                :datetime
#  status                      :string(255)      default("published")
#  summary                     :text
#  title                       :string(255)
#  url_name                    :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#  legacy_id                   :string(255)
#
# Indexes
#
#  index_blogs_on_author_trigram  (author) USING gin
#  index_blogs_on_body_trigram    (body) USING gin
#  index_blogs_on_status          (status)
#  index_blogs_on_title_trigram   (title) USING gin
#  index_blogs_on_url_name        (url_name)
#
