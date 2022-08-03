# frozen_string_literal: true

class FranchiseArticle < ActiveRecord::Base
  include Rails.application.routes.mounted_helpers
  extend FriendlyId
  include PgSearch::Model
  pg_search_scope :search_by_name_author_slug_and_url, against: [:author, :title, :url, :summary , :created_at],
  using: {
    tsearch: {
      prefix: true,
      any_word: true
    }
  }
  friendly_id :title, use: :slugged
  paginates_per 10

  belongs_to :franchise_country, class_name: "Country", foreign_key: :country_id
  has_many :categoriables, as: :item, dependent: :destroy
  has_many :categories, through: :categoriables

  has_many :taggables, as: :item, dependent: :destroy
  has_many :tags, through: :taggables


  validates :title, :slug, :summary, presence: true
  validates :url, presence: true, if: :press?
  validates :body, presence: true, if: :blog?

  enum country: {
    us: 0,
    ca: 1,
    br: 2
  }

  enum kind: {
    blog:  0,
    press: 1
  }

  has_attached_file :image, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { full_width: '960>', directory: '375x375#', thumbnail: '100x100#' }, s3_protocol: :https
  validates_attachment_content_type :image, content_type: %r{\Aimage/.*\Z}
  attr_accessor :delete_image, :delete_thumbnail

  before_validation { image.destroy if delete_image == '1' }

  has_attached_file :thumbnail, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { full_width: '960>', directory: '375x375#', thumbnail: '100x100#' }, s3_protocol: :https
  validates_attachment_content_type :thumbnail, content_type: %r{\Aimage/.*\Z}

  before_validation { thumbnail.destroy if delete_thumbnail == '1' }

  scope :by_category, lambda { |category_id|
    includes(:categories).where(categories: { id: category_id })
  }

  scope :search_by_query, lambda { |query|
    where('LOWER(title) LIKE :query OR LOWER(body) LIKE :query OR LOWER(author) LIKE :query', query: "%#{query.downcase.gsub(/\s/, '%')}%")
  }

  scope :by_country_or_blank, ->(country) { where(country: [nil, FranchiseArticle.countries[country.to_s]]) }

  def safe_title
    EscapeUtils.escape_url(title.gsub(/&#8211;/, '-'))
  end

  def real_url
    press? ? url.html_safe : franchising_engine.franchise_article_path(self)
  end

  def should_generate_new_friendly_id?
    title_changed?
  end

  def as_json(_options = {})
    super(methods: %i[category tag image_url thumbnail_url country_name ])
  end

  def category
    self.categories&.map{ | a| {id: a.id, name: a.name} }
  end

  def tag
    self.tags&.map{ | a| {id: a.id, name: a.name} }
  end

  def country_name
    franchise_country ? franchise_country.name : ''
  end

  def image_url
    image.url(:full_width).gsub('/solasalonstylists/', '/solasalonstudios/') if image.present?
  end

  def thumbnail_url
    thumbnail.url(:full_width).gsub('/solasalonstylists/', '/solasalonstudios/') if thumbnail.present?
  end
end

# == Schema Information
#
# Table name: franchise_articles
#
#  id                     :integer          not null, primary key
#  author                 :string
#  body                   :text
#  country                :integer
#  image_content_type     :string
#  image_file_name        :string
#  image_file_size        :integer
#  image_updated_at       :datetime
#  kind                   :integer          default(0), not null
#  slug                   :string           not null
#  summary                :text
#  thumbnail_content_type :string
#  thumbnail_file_name    :string
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  title                  :string           not null
#  url                    :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  country_id             :integer
#
# Indexes
#
#  index_franchise_articles_on_country  (country)
#  index_franchise_articles_on_slug     (slug) UNIQUE
#  index_franchise_articles_on_title    (title)
#
#
