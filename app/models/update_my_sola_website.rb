class UpdateMySolaWebsite < ActiveRecord::Base

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

  after_create :email_franchisee

  after_update :publish_if_approved

  private

  def email_franchisee
    p "EMAIL FRANCHISEE"
  end

  def email_stylist
    p "EMAIL STYLIST"
  end

  def publish
    require "open-uri"

    p "PUBLISH"

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

    if image_1_url.present?
      begin
        stylist.image_1 = URI.parse(image_1_url)
        p "setting image 1 #{image_1_url}, #{stylist.image_2}"
      rescue => e
        p "image 1 error = #{e.inspect}"
      end
    else
      stylist.image_1 = nil
    end

    if image_2_url.present?
      begin
        stylist.image_2 = URI.parse(image_2_url)
        p "setting image 2 #{image_2_url}, #{stylist.image_2}"
      rescue => e
        p "image 2 error = #{e.inspect}"
      end
    else
      stylist.image_2 = nil
    end

    if image_3_url.present?
      begin
        stylist.image_3 = URI.parse(image_3_url) 
        p "setting image 3 #{image_3_url}, #{stylist.image_3}"
      rescue => e
        p "image 3 error = #{e.inspect}"
      end
    else
      stylist.image_3 = nil
    end

    if image_4_url.present?
      begin
        stylist.image_4 = URI.parse(image_4_url)
        p "setting image 4 #{image_4_url}, #{stylist.image_4}"
      rescue => e
        p "image 4 error = #{e.inspect}"
      end
    else
      stylist.image_4 = nil
    end

    if image_5_url.present?
      begin
        stylist.image_5 = URI.parse(image_5_url)
        p "setting image 5 #{image_5_url}, #{stylist.image_5}"
      rescue => e
        p "image 5 error = #{e.inspect}"
      end
    else
      stylist.image_5 = nil
    end

    if image_6_url.present?
      begin
        stylist.image_6 = URI.parse(image_6_url)
        p "setting image 6 #{image_3_url}, #{stylist.image_6}"
      rescue => e
        p "image 6 error = #{e.inspect}"
      end
    else
      stylist.image_6 = nil
    end

    if image_7_url.present?
      begin
        stylist.image_7 = URI.parse(image_7_url) 
        p "setting image 7 #{image_7_url}, #{stylist.image_7}"
      rescue => e
        p "image 7 error = #{e.inspect}"
      end
    else
      stylist.image_7 = nil
    end

    if image_8_url.present?
      begin
        stylist.image_8 = URI.parse(image_8_url) 
        p "setting image 8 #{image_8_url}, #{stylist.image_8}"
      rescue => e
        p "image 8 error = #{e.inspect}"
      end
    else
      stylist.image_8 = nil
    end

    if image_9_url.present?
      begin
        stylist.image_9 = URI.parse(image_9_url) 
        p "setting image 9 #{image_9_url}, #{stylist.image_9}"
      rescue => e
        p "image 9 error = #{e.inspect}"
      end
    else
      stylist.image_9 = nil
    end

    if image_10_url.present?
      begin
        stylist.image_10 = URI.parse(image_10_url) 
        p "setting image 10 #{image_10_url}, #{stylist.image_10}"
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
      publish
      email_stylist
    end
  end

end