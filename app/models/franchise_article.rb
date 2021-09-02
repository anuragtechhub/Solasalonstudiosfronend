class FranchiseArticle < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :categoriables, as: :item, dependent: :destroy
  has_many :categories, through: :categoriables

  has_many :taggables, as: :item, dependent: :destroy
  has_many :tags, through: :taggables

  validates :title, :slug, :summary, presence: true
  validates :url, presence: true, if: :press?
  validates :body, presence: true, if: :blog?

  enum country: {
    us: 0,
    ca: 1
  }

  enum kind: {
    blog: 0,
    press: 1
  }

  has_attached_file :image, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => ENV['S3_HOST_ALIAS'], :styles => { :full_width => '960>', :directory => '375x375#', :thumbnail => '100x100#' }, processors: [:thumbnail, :compression], :s3_protocol => :https
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image
  before_validation { self.image.destroy if self.delete_image == '1' }

  scope :by_category, ->(category_id) {
    includes(:categories).where(categories: {id: category_id})
  }

  scope :search_by_query, ->(query) {
    where('LOWER(title) LIKE :query OR LOWER(body) LIKE :query OR LOWER(author) LIKE :query', query: "%#{query.downcase.gsub(/\s/, '%')}%")
  }
end

# == Schema Information
#
# Table name: franchise_articles
#
#  id                 :integer          not null, primary key
#  author             :string
#  body               :text
#  country            :integer
#  image_content_type :string
#  image_file_name    :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  kind               :integer          default(0), not null
#  slug               :string           not null
#  summary            :text
#  title              :string           not null
#  url                :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_franchise_articles_on_country  (country)
#  index_franchise_articles_on_slug     (slug) UNIQUE
#  index_franchise_articles_on_title    (title)
#
