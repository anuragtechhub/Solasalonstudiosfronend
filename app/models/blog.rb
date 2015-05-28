class Blog < ActiveRecord::Base

  has_many :blog_blog_categories
  has_many :blog_categories, :through => :blog_blog_categories

  validates :title, :presence => true
  validates :url_name, :presence => true, :uniqueness => true

  has_attached_file :carousel_image, :styles => { :full_width => '960#', :directory => '375x375#', :thumbnail => '100x100#', :carousel => '400x540#' }, :s3_protocol => :https
  validates_attachment_content_type :carousel_image, :content_type => /\Aimage\/.*\Z/

  has_attached_file :image, :styles => { :full_width => '960#', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  has_paper_trail

  def safe_title
    EscapeUtils.escape_url(title.gsub(/&#8211;/, '-'))
  end

  def related_blogs
    blogs = []
    
    if self.blog_categories.size > 0
      self.blog_categories.each do |category|
        if category.blogs && category.blogs.size > 0
          category.blogs.order(:created_at => :desc).each do |blog|
            if blog.id != self.id && !blogs.include?(blog)
              blogs << blog
              break if blogs.size == 3
            end
          end
        end
        break if blogs.size == 3
      end
    end

    if blogs.size < 3
      Blog.order(:created_at => :desc).limit(5).each do |blog|
        if blog.id != self.id && !blogs.include?(blog)
          blogs << blog
          break if blogs.size == 3
        end
      end
    end

    blogs
  end

  def to_param
    url_name
  end

end