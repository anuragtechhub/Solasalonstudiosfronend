class Blog < ActiveRecord::Base

  after_destroy :touch_blog
  before_create :generate_url_name
  before_save :fix_url_name

  has_many :blog_blog_categories
  has_many :blog_categories, :through => :blog_blog_categories

  validates :title, :presence => true
  #validates :url_name, :presence => true, :uniqueness => true

  has_attached_file :carousel_image, :styles => { :full_width => '960#', :directory => '375x375#', :thumbnail => '100x100#', :carousel => '400x540#' }, :s3_protocol => :https
  validates_attachment_content_type :carousel_image, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_carousel_image
  before_validation { self.carousel_image.destroy if self.delete_carousel_image == '1' }

  has_attached_file :image, :styles => { :full_width => '960#', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image
  before_validation { self.image.destroy if self.delete_image == '1' }

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

  def status_enum
    [['Published', 'published'], ['Scheduled', 'scheduled'], ['Draft', 'draft']]
  end

  def to_param
    url_name
  end

  private

  def generate_url_name
    if self.title
      url = self.title.downcase.gsub(/[^0-9a-zA-Z]/, '_') 
      count = 1
      
      while Blog.where(:url_name => url).size > 0 do
        url = "#{url}#{count}"
        count = count + 1
      end

      self.url_name = url
    end
  end

  def touch_blog
    Blog.all.first.touch
  end

  def fix_url_name
    self.url_name = self.url_name.gsub(/[^0-9a-zA-Z]/, '_') if self.url_name.present?
  end

end