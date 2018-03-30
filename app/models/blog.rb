class Blog < ActiveRecord::Base

  after_destroy :touch_blog
  before_create :generate_url_name
  before_save :fix_url_name, :https_images, :check_publish_date

  has_many :blog_blog_categories
  has_many :blog_categories, :through => :blog_blog_categories
  has_many :blog_countries
  has_many :countries, :through => :blog_countries

  validates :title, :status, :presence => true
  validates :countries, :presence => true
  validates :url_name, :presence => true, :uniqueness => true

  has_attached_file :carousel_image, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :full_width => '960#', :directory => '375x375#', :thumbnail => '100x100#', :carousel => '400x540#' }, :s3_protocol => :https
  validates_attachment_content_type :carousel_image, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_carousel_image
  before_validation { self.carousel_image.destroy if self.delete_carousel_image == '1' }

  has_attached_file :image, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :full_width => '960#', :directory => '375x375#', :thumbnail => '100x100#' }, :s3_protocol => :https
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image
  before_validation { self.image.destroy if self.delete_image == '1' }

  has_paper_trail

  def safe_title
    EscapeUtils.escape_url(title.gsub(/&#8211;/, '-'))
  end

  def related_blogs
    blogs = []

    #p "start related blogs..."

    #p "bl.size=#{self.blog_categories.size}"
    
    if self.blog_categories.length > 0
      #p "we got categories #{blog_categories.size}"
      self.blog_categories.each do |category|
        if category.blogs && category.blogs.length > 0
          category.blogs.order(:created_at => :desc).each do |blog|
            if blog.id != self.id && !blogs.include?(blog)
              blogs << blog
              break if blogs.length == 3
            end
          end
        end
        break if blogs.length == 3
      end
    end

    #p "blogs here=#{blogs.size}"

    if blogs.length < 3
      Blog.order(:created_at => :desc).limit(5).each do |blog|
        if blog.id != self.id && !blogs.include?(blog)
          blogs << blog
          break if blogs.length == 3
        end
      end
    end

    #p "related_blogs=#{blogs.inspect}"

    blogs
  end

  def mysola_category
    blog_categories.each do |cat|
      return true if cat.id == 11
    end
    return false
  end

  def status_enum
    [['Published', 'published'], ['Draft', 'draft']]
  end

  def to_param
    url_name
  end

  def fix_url_name
    if self.url_name.present?
      self.url_name = self.url_name.gsub(/[^0-9a-zA-Z]/, '_')
      self.url_name = self.url_name.gsub('___', '_')
      self.url_name = self.url_name.gsub('_-_', '_')
      self.url_name = self.url_name.split('_')
      self.url_name = self.url_name.map{ |u| u.downcase }
      self.url_name = self.url_name.join('-')
    end
  end

  def canonical_path
    "/blog/#{url_name}"
  end

  def canonical_url(locale=:en)
    "https://www.solasalonstudios.#{locale != :en ? 'ca' : 'com'}/blog/#{url_name}"
  end

  private

  def generate_url_name
    if self.title
      url = self.title.downcase.gsub(/[^0-9a-zA-Z]/, '-') 
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

  def https_images
    if self.body
      self.body = self.body.gsub(/<img[^>]+\>/) { |img|
        img.gsub(/src="http:/, 'src="https:')
      }
    end
  end

  def check_publish_date
    if self.publish_date && self.publish_date <= DateTime.now
      self.status = 'published' 
    elsif self.publish_date && self.publish_date > DateTime.now
      self.status = 'draft'
    elsif self.status == 'published' && self.publish_date == nil
      self.publish_date = self.created_at || DateTime.now
    else
      self.status = 'draft'
      self.publish_date = nil
    end
  end

end