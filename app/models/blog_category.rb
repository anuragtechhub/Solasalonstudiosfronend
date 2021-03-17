class BlogCategory < ActiveRecord::Base

  has_paper_trail

  before_save :fix_url_name

  has_many :blog_blog_categories
  has_many :blogs, :through => :blog_blog_categories

  validates :name, :presence => true
  validates :url_name, :presence => true, :uniqueness => true

  def to_param
    url_name
  end

  # TODO replace this bullshit with friendly_id.
  def fix_url_name
    if self.url_name.present?
      self.url_name = self.url_name
                          .downcase
                          .gsub(/\s+/,'_')
                          .gsub(/[^0-9a-zA-Z]/, '_')
                          .gsub('___', '_')
                          .gsub('_-_', '_')
                          .gsub('_', '-')
    end
  end

end
