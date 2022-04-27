# frozen_string_literal: true

class BlogCategory < ActiveRecord::Base
  has_paper_trail

  before_save :fix_url_name

  has_many :blog_blog_categories
  has_many :blogs, through: :blog_blog_categories

  validates :name, presence: true
  validates :url_name, presence: true, uniqueness: true

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

  def as_json(_options = {})
    super(only: %i[name url_name])
  end
end

# == Schema Information
#
# Table name: blog_categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  url_name   :string(255)
#  created_at :datetime
#  updated_at :datetime
#  legacy_id  :string(255)
#
# Indexes
#
#  index_blog_categories_on_url_name  (url_name)
#
