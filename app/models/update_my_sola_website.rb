class UpdateMySolaWebsite < ActiveRecord::Base

  require 'RMagick'
  require 'uri'

  belongs_to :stylist

  belongs_to :testimonial_1, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_1'
  belongs_to :testimonial_2, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_2'
  belongs_to :testimonial_3, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_3'
  belongs_to :testimonial_4, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_4'
  belongs_to :testimonial_5, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_5'
  belongs_to :testimonial_6, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_6'
  belongs_to :testimonial_7, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_7'
  belongs_to :testimonial_8, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_8'
  belongs_to :testimonial_9, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_9'
  belongs_to :testimonial_10, :class_name => 'Testimonial', :foreign_key => 'testimonial_id_10'

  has_attached_file :image_1, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_1, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_1
  before_validation { self.image_1.destroy if self.delete_image_1 == '1' }

  has_attached_file :image_2, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_2, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_2
  before_validation { self.image_2.destroy if self.delete_image_2 == '1' }

  has_attached_file :image_3, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_3, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_3
  before_validation { self.image_3.destroy if self.delete_image_3 == '1' }

  has_attached_file :image_4, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_4, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_4
  before_validation { self.image_4.destroy if self.delete_image_4 == '1' }

  has_attached_file :image_5, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_5, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_5
  before_validation { self.image_5.destroy if self.delete_image_5 == '1' }

  has_attached_file :image_6, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_6, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_6
  before_validation { self.image_6.destroy if self.delete_image_6 == '1' }

  has_attached_file :image_7, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_7, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_7
  before_validation { self.image_7.destroy if self.delete_image_7 == '1' }

  has_attached_file :image_8, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_8, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_8
  before_validation { self.image_8.destroy if self.delete_image_8 == '1' }

  has_attached_file :image_9, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_9, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image_9
  before_validation { self.image_9.destroy if self.delete_image_9 == '1' }

  has_attached_file :image_10, :url => ":s3_alias_url", :path => ":class/:attachment/:id_partition/:style/:filename", :s3_host_alias => 'd3p1kyyvw4qtho.cloudfront.net', :styles => { :carousel => '630x>' }, :s3_protocol => :https, :source_file_options => {:all => '-auto-orient'}
  validates_attachment_content_type :image_10, :content_type => /\Aimage\/.*\Z/    
  attr_accessor :delete_image_10
  before_validation { self.image_10.destroy if self.delete_image_10 == '1' }

  before_update :auto_orient_images
  after_update :publish_if_approved

  def location
    stylist.location if stylist
  end

  def force_orient
    if image_1_url_changed?
      self.image_1 = open(image_1_url)
    end
  
    if image_2_url_changed?
      self.image_2 = open(image_2_url)
    end

    if image_3_url_changed?
      self.image_3 = open(image_3_url)
    end    

    if image_4_url_changed?
      self.image_4 = open(image_4_url)
    end       

    if image_5_url_changed?
      self.image_5 = open(image_5_url)
    end         

    if image_6_url_changed?
      self.image_6 = open(image_6_url)
    end 

    if image_7_url_changed?
      self.image_7 = open(image_7_url)
    end               

    if image_8_url_changed?
      self.image_8 = open(image_8_url)
    end        

    if image_9_url_changed?
      self.image_9 = open(image_9_url)
    end      

    if image_10_url_changed?
      self.image_10 = open(image_10_url)
    end 

    self.save
  end

  private

  def auto_orient_images
    p "auto_orient_images!"
    if image_1_url_changed?
      p "image_1 changed yo"
      self.image_1 = open(image_1_url)
    end
  
    if image_2_url_changed?
      self.image_2 = open(image_2_url)
    end

    if image_3_url_changed?
      self.image_3 = open(image_3_url)
    end    

    if image_4_url_changed?
      self.image_4 = open(image_4_url)
    end       

    if image_5_url_changed?
      self.image_5 = open(image_5_url)
    end         

    if image_6_url_changed?
      self.image_6 = open(image_6_url)
    end 

    if image_7_url_changed?
      self.image_7 = open(image_7_url)
    end               

    if image_8_url_changed?
      self.image_8 = open(image_8_url)
    end        

    if image_9_url_changed?
      self.image_9 = open(image_9_url)
    end      

    if image_10_url_changed?
      self.image_10 = open(image_10_url)
    end          
  end

  def email_stylist
    PublicWebsiteMailer.stylist_website_is_updated(self).deliver
  end

  def publish
    stylist.name = name
    stylist.email_address = email_address
    stylist.phone_number = phone_number
    
    stylist.business_name = business_name
    stylist.work_hours = work_hours
    stylist.biography = biography

    stylist.website_url = website_url
    stylist.booking_url = booking_url

    stylist.facebook_url = facebook_url
    stylist.google_plus_url = google_plus_url
    stylist.instagram_url = instagram_url
    stylist.linkedin_url = linkedin_url
    stylist.pinterest_url = pinterest_url
    stylist.twitter_url = twitter_url
    stylist.yelp_url = yelp_url

    stylist.brows = brows
    stylist.hair = hair
    stylist.hair_extensions = hair_extensions
    stylist.laser_hair_removal = laser_hair_removal
    stylist.eyelash_extensions = eyelash_extensions
    stylist.makeup = makeup
    stylist.massage = massage
    stylist.nails = nails
    stylist.permanent_makeup = permanent_makeup
    stylist.skin = skin
    stylist.tanning = tanning
    stylist.teeth_whitening = teeth_whitening
    stylist.threading = threading
    stylist.waxing = waxing
    stylist.other_service = other_service

    if testimonial_1 && testimonial_1.text.present?
      stylist.testimonial_id_1 = testimonial_id_1 
    else
      stylist.testimonial_id_1 = nil
    end

    if testimonial_2 && testimonial_2.text.present?
      stylist.testimonial_id_2 = testimonial_id_2
    else
      stylist.testimonial_id_2 = nil
    end

    if testimonial_3 && testimonial_3.text.present?
      stylist.testimonial_id_3 = testimonial_id_3
    else
      stylist.testimonial_id_3 = nil
    end

    if testimonial_4 && testimonial_4.text.present?
      stylist.testimonial_id_4 = testimonial_id_4
    else
      stylist.testimonial_id_4 = nil
    end

    if testimonial_5 && testimonial_5.text.present?
      stylist.testimonial_id_5 = testimonial_id_5
    else
      stylist.testimonial_id_5 = nil
    end

    if testimonial_6 && testimonial_6.text.present?
      stylist.testimonial_id_6 = testimonial_id_6
    else
      stylist.testimonial_id_6 = nil
    end

    if testimonial_7 && testimonial_7.text.present?
      stylist.testimonial_id_7 = testimonial_id_7
    else
      stylist.testimonial_id_7 = nil
    end

    if testimonial_8 && testimonial_8.text.present?
      stylist.testimonial_id_8 = testimonial_id_8
    else
      stylist.testimonial_id_8 = nil
    end

    if testimonial_9 && testimonial_9.text.present?
      stylist.testimonial_id_9 = testimonial_id_9
    else
      stylist.testimonial_id_9 = nil
    end

    if testimonial_10 && testimonial_10.text.present?
      stylist.testimonial_id_10 = testimonial_id_10
    else
      stylist.testimonial_id_10 = nil
    end

    if image_1.present?
      p "image_1 is present"
      begin
        stylist.image_1 = URI.parse(image_1.url(:carousel))
        p "done set image_1"
      rescue => e
        p "image 1 error = #{e.inspect}"
      end
    else
      stylist.image_1 = nil
    end

    if image_2.present?
      begin
        stylist.image_2 = URI.parse(image_2.url(:carousel))
      rescue => e
        p "image 2 error = #{e.inspect}"
      end
    else
      stylist.image_2 = nil
    end

    if image_3.present?
      begin
        stylist.image_3 = URI.parse(image_3.url(:carousel)) 
      rescue => e
        p "image 3 error = #{e.inspect}"
      end
    else
      stylist.image_3 = nil
    end

    if image_4.present?
      begin
        stylist.image_4 = URI.parse(image_4.url(:carousel))
      rescue => e
        p "image 4 error = #{e.inspect}"
      end
    else
      stylist.image_4 = nil
    end

    if image_5.present?
      begin
        stylist.image_5 = URI.parse(image_5.url(:carousel))
      rescue => e
        p "image 5 error = #{e.inspect}"
      end
    else
      stylist.image_5 = nil
    end

    if image_6.present?
      begin
        stylist.image_6 = URI.parse(image_6.url(:carousel))
      rescue => e
        p "image 6 error = #{e.inspect}"
      end
    else
      stylist.image_6 = nil
    end

    if image_7.present?
      begin
        stylist.image_7 = URI.parse(image_7.url(:carousel)) 
      rescue => e
        p "image 7 error = #{e.inspect}"
      end
    else
      stylist.image_7 = nil
    end

    if image_8.present?
      begin
        stylist.image_8 = URI.parse(image_8.url(:carousel)) 
      rescue => e
        p "image 8 error = #{e.inspect}"
      end
    else
      stylist.image_8 = nil
    end

    if image_9.present?
      begin
        stylist.image_9 = URI.parse(image_9.url(:carousel)) 
      rescue => e
        p "image 9 error = #{e.inspect}"
      end
    else
      stylist.image_9 = nil
    end

    if image_10.present?
      begin
        stylist.image_10 = URI.parse(image_10.url(:carousel)) 
      rescue => e
        p "image 10 error = #{e.inspect}"
      end
    else
      stylist.image_10 = nil
    end

    stylist.save
  end

  def publish_if_approved
    if approved_was != true && approved == true
      #p "publish! this puppy is approved"
      publish
      email_stylist
    else
      #p "do not publish - not approved :("
    end
  end

end