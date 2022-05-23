# frozen_string_literal: true

class UpdateMySolaWebsite < ActiveRecord::Base
  SOCIAL_PREFIXES = {
    instagram: 'https://www.instagram.com/',
    facebook:  'https://www.facebook.com/',
    twitter:   'https://www.twitter.com/',
    yelp:      'https://www.yelp.com/biz/',
    linkedin:  'https://www.linkedin.com/in/',
    pinterest: 'https://www.pinterest.com/'
  }.freeze

  require 'RMagick'
  require 'uri'

  has_paper_trail

  belongs_to :stylist

  belongs_to :testimonial_1, class_name: 'Testimonial', foreign_key: 'testimonial_id_1'
  belongs_to :testimonial_2, class_name: 'Testimonial', foreign_key: 'testimonial_id_2'
  belongs_to :testimonial_3, class_name: 'Testimonial', foreign_key: 'testimonial_id_3'
  belongs_to :testimonial_4, class_name: 'Testimonial', foreign_key: 'testimonial_id_4'
  belongs_to :testimonial_5, class_name: 'Testimonial', foreign_key: 'testimonial_id_5'
  belongs_to :testimonial_6, class_name: 'Testimonial', foreign_key: 'testimonial_id_6'
  belongs_to :testimonial_7, class_name: 'Testimonial', foreign_key: 'testimonial_id_7'
  belongs_to :testimonial_8, class_name: 'Testimonial', foreign_key: 'testimonial_id_8'
  belongs_to :testimonial_9, class_name: 'Testimonial', foreign_key: 'testimonial_id_9'
  belongs_to :testimonial_10, class_name: 'Testimonial', foreign_key: 'testimonial_id_10'

  accepts_nested_attributes_for :testimonial_1,
                                :testimonial_2,
                                :testimonial_3,
                                :testimonial_4,
                                :testimonial_5,
                                :testimonial_6,
                                :testimonial_7,
                                :testimonial_8,
                                :testimonial_9,
                                :testimonial_10, reject_if: :all_blank, allow_destroy: false

  before_validation :process_social_links
  before_save :auto_format_phone_number

  validates :email_address, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :name, presence: true

  has_attached_file :image_1, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https, source_file_options: { all: '-auto-orient' }
  validates_attachment_content_type :image_1, content_type: %r{\Aimage/.*\Z}
  attr_accessor :delete_image_1, :delete_image_2, :delete_image_3, :delete_image_4, :delete_image_5, :delete_image_6, :delete_image_7, :delete_image_8, :delete_image_9, :delete_image_10

  before_validation { image_1.destroy if delete_image_1 == '1' }

  has_attached_file :image_2, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https, source_file_options: { all: '-auto-orient' }
  validates_attachment_content_type :image_2, content_type: %r{\Aimage/.*\Z}

  before_validation { image_2.destroy if delete_image_2 == '1' }

  has_attached_file :image_3, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https, source_file_options: { all: '-auto-orient' }
  validates_attachment_content_type :image_3, content_type: %r{\Aimage/.*\Z}

  before_validation { image_3.destroy if delete_image_3 == '1' }

  has_attached_file :image_4, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https, source_file_options: { all: '-auto-orient' }
  validates_attachment_content_type :image_4, content_type: %r{\Aimage/.*\Z}

  before_validation { image_4.destroy if delete_image_4 == '1' }

  has_attached_file :image_5, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https, source_file_options: { all: '-auto-orient' }
  validates_attachment_content_type :image_5, content_type: %r{\Aimage/.*\Z}

  before_validation { image_5.destroy if delete_image_5 == '1' }

  has_attached_file :image_6, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https, source_file_options: { all: '-auto-orient' }
  validates_attachment_content_type :image_6, content_type: %r{\Aimage/.*\Z}

  before_validation { image_6.destroy if delete_image_6 == '1' }

  has_attached_file :image_7, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https, source_file_options: { all: '-auto-orient' }
  validates_attachment_content_type :image_7, content_type: %r{\Aimage/.*\Z}

  before_validation { image_7.destroy if delete_image_7 == '1' }

  has_attached_file :image_8, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https, source_file_options: { all: '-auto-orient' }
  validates_attachment_content_type :image_8, content_type: %r{\Aimage/.*\Z}

  before_validation { image_8.destroy if delete_image_8 == '1' }

  has_attached_file :image_9, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https, source_file_options: { all: '-auto-orient' }
  validates_attachment_content_type :image_9, content_type: %r{\Aimage/.*\Z}

  before_validation { image_9.destroy if delete_image_9 == '1' }

  has_attached_file :image_10, url: ':s3_alias_url', path: ':class/:attachment/:id_partition/:style/:filename', s3_host_alias: ENV.fetch('S3_HOST_ALIAS', nil), styles: { carousel: '630x>' }, s3_protocol: :https, source_file_options: { all: '-auto-orient' }
  validates_attachment_content_type :image_10, content_type: %r{\Aimage/.*\Z}

  before_validation { image_10.destroy if delete_image_10 == '1' }

  before_save :force_orient
  before_update :auto_orient_images
  after_update :publish_if_approved

  # Check the logic. Don't send on destroy..make sure it sends only after update from the api. Probably add attr_reader
  after_save :email_franchisee
  # Same here
  after_save :reserve_stylist
  before_save :remove_unwanted_text

  scope :pending, -> { where(approved: false) }
  scope :approved, -> { where(approved: true) }

  def location
    stylist&.location
  end

  def force_orient
    # if image_1_url_changed?
    if image_1_url.present?
      Rails.logger.debug { "there is an image_1=#{image_1_url}" }
      begin
        self.image_1 = open(image_1_url)
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
      Rails.logger.debug { "done opening image_1 #{image_1.url(:original)}" }
    end

    # if image_2_url_changed?
    if image_2_url.present?
      Rails.logger.debug { "there is an image_2=#{image_2_url}" }
      begin
        self.image_2 = open(image_2_url)
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
      Rails.logger.debug { "done opening image_2 #{image_2.url(:original)}" }
    end

    # if image_3_url_changed?
    if image_3_url.present?
      Rails.logger.debug { "there is an image_3=#{image_3_url}" }
      begin
        self.image_3 = open(image_3_url)
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
      Rails.logger.debug { "done opening image_3 #{image_3.url(:original)}" }
    end

    # if image_4_url_changed?
    if image_4_url.present?
      Rails.logger.debug { "there is an image_4=#{image_4_url}" }
      begin
        self.image_4 = open(image_4_url)
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
      Rails.logger.debug { "done opening image_4 #{image_4.url(:original)}" }
    end

    # if image_5_url_changed?
    if image_5_url.present?
      Rails.logger.debug { "there is an image_5=#{image_5_url}" }
      begin
        self.image_5 = open(image_5_url)
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
      Rails.logger.debug { "done opening image_5 #{image_5.url(:original)}" }
    end

    # if image_6_url_changed?
    if image_6_url.present?
      Rails.logger.debug { "there is an image_6=#{image_6_url}" }
      begin
        self.image_6 = open(image_6_url)
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
      Rails.logger.debug { "done opening image_6 #{image_6.url(:original)}" }
    end

    # if image_7_url_changed?
    if image_7_url.present?
      Rails.logger.debug { "there is an image_7=#{image_7_url}" }
      begin
        self.image_7 = open(image_7_url)
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
      Rails.logger.debug { "done opening image_7 #{image_7.url(:original)}" }
    end

    # if image_8_url_changed?
    if image_8_url.present?
      Rails.logger.debug { "there is an image_8=#{image_8_url}" }
      begin
        self.image_8 = open(image_8_url)
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
      Rails.logger.debug { "done opening image_8 #{image_8.url(:original)}" }
    end

    # if image_9_url_changed?
    if image_9_url.present?
      Rails.logger.debug { "there is an image_9=#{image_9_url}" }
      begin
        self.image_9 = open(image_9_url)
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
      Rails.logger.debug { "done opening image_9 #{image_9.url(:original)}" }
    end

    # if image_10_url_changed?
    if image_10_url.present?
      Rails.logger.debug { "there is an image_10=#{image_10_url}" }
      begin
        self.image_10 = open(image_10_url)
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
      Rails.logger.debug { "done opening image_10 #{image_10.url(:original)}" }
    end
  rescue StandardError => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
  end

  def force_orient_and_save
    force_orient

    save
  rescue StandardError => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
  end

  def publish
    stylist.name = name
    stylist.email_address = email_address
    stylist.phone_number = phone_number

    if reserved == true || reserved == false
      stylist.reserved = reserved
    end

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
    stylist.tik_tok_url = tik_tok_url

    stylist.barber = barber
    stylist.brows = brows
    stylist.botox = botox
    stylist.hair = hair
    stylist.hair_extensions = hair_extensions
    stylist.laser_hair_removal = laser_hair_removal
    stylist.eyelash_extensions = eyelash_extensions
    stylist.makeup = makeup
    stylist.massage = massage
    stylist.microblading = microblading
    stylist.nails = nails
    stylist.permanent_makeup = permanent_makeup
    stylist.skin = skin
    stylist.tanning = tanning
    stylist.teeth_whitening = teeth_whitening
    stylist.threading = threading
    stylist.waxing = waxing
    stylist.other_service = other_service

    stylist.testimonial_id_1 = if testimonial_1 && testimonial_1.text.present?
                                 testimonial_id_1
                               end

    stylist.testimonial_id_2 = if testimonial_2 && testimonial_2.text.present?
                                 testimonial_id_2
                               end

    stylist.testimonial_id_3 = if testimonial_3 && testimonial_3.text.present?
                                 testimonial_id_3
                               end

    stylist.testimonial_id_4 = if testimonial_4 && testimonial_4.text.present?
                                 testimonial_id_4
                               end

    stylist.testimonial_id_5 = if testimonial_5 && testimonial_5.text.present?
                                 testimonial_id_5
                               end

    stylist.testimonial_id_6 = if testimonial_6 && testimonial_6.text.present?
                                 testimonial_id_6
                               end

    stylist.testimonial_id_7 = if testimonial_7 && testimonial_7.text.present?
                                 testimonial_id_7
                               end

    stylist.testimonial_id_8 = if testimonial_8 && testimonial_8.text.present?
                                 testimonial_id_8
                               end

    stylist.testimonial_id_9 = if testimonial_9 && testimonial_9.text.present?
                                 testimonial_id_9
                               end

    stylist.testimonial_id_10 = if testimonial_10 && testimonial_10.text.present?
                                  testimonial_id_10
                                end

    if image_1.present?
      Rails.logger.debug 'image_1 is present'
      begin
        stylist.image_1 = URI.parse(image_1.url(:carousel))
        Rails.logger.debug { "done set image_1 #{image_1.url(:original)}" }
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
    else
      # stylist.image_1 = nil
    end

    if image_2.present?
      begin
        stylist.image_2 = URI.parse(image_2.url(:carousel))
        Rails.logger.debug { "done set image_2 #{image_2.url(:original)}" }
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
    else
      # stylist.image_2 = nil
    end

    if image_3.present?
      begin
        stylist.image_3 = URI.parse(image_3.url(:carousel))
        Rails.logger.debug { "done set image_3 #{image_3.url(:original)}" }
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
    else
      # stylist.image_3 = nil
    end

    if image_4.present?
      begin
        stylist.image_4 = URI.parse(image_4.url(:carousel))
        Rails.logger.debug { "done set image_4 #{image_4.url(:original)}" }
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
    else
      # stylist.image_4 = nil
    end

    if image_5.present?
      begin
        stylist.image_5 = URI.parse(image_5.url(:carousel))
        Rails.logger.debug { "done set image_5 #{image_5.url(:original)}" }
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
    else
      # stylist.image_5 = nil
    end

    if image_6.present?
      begin
        stylist.image_6 = URI.parse(image_6.url(:carousel))
        Rails.logger.debug { "done set image_6 #{image_6.url(:original)}" }
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
    else
      # stylist.image_6 = nil
    end

    if image_7.present?
      begin
        stylist.image_7 = URI.parse(image_7.url(:carousel))
        Rails.logger.debug { "done set image_7 #{image_7.url(:original)}" }
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
    else
      # stylist.image_7 = nil
    end

    if image_8.present?
      begin
        stylist.image_8 = URI.parse(image_8.url(:carousel))
        Rails.logger.debug { "done set image_8 #{image_8.url(:original)}" }
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
    else
      # stylist.image_8 = nil
    end

    if image_9.present?
      begin
        stylist.image_9 = URI.parse(image_9.url(:carousel))
        Rails.logger.debug { "done set image_9 #{image_9.url(:original)}" }
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
    else
      # stylist.image_9 = nil
    end

    if image_10.present?
      begin
        stylist.image_10 = URI.parse(image_10.url(:carousel))
        Rails.logger.debug { "done set image_10 #{image_10.url(:original)}" }
      rescue StandardError => e
        Rollbar.error(e)
        NewRelic::Agent.notice_error(e)
      end
    else
      # stylist.image_10 = nil
    end

    # stylist.save
    stylist
  end

  def publish_and_save
    stylist = publish
    stylist.save
  end

  def changes_requested
    attrs = attributes.except('id', 'stylist_id', 'approved', 'google_plus_url', 'created_at', 'updated_at').reject do |key, value|
      stylist.send(key) == value || key.include?('image_') || key.include?('testimonial_')
    end
    (1..10).each do |number|
      key = "testimonial_#{number}"
      if (value = send(key)).present?
        current_value = stylist.send(key)
        attrs[key] = value if current_value.blank? || current_value.attributes.except('id', 'created_at', 'updated_at') != value.attributes.except('id', 'created_at', 'updated_at')
      end

      key = "image_#{number}_url"
      if (value = send(key)).present? && (stylist.send(key) != value)
        attrs[key] = value
      end

      key = "image_#{number}"
      if (value = send(key)).present?
        attrs[key] = value.url
        attrs.delete("#{key}_url")
      end
    end
    attrs
  end

  def email_franchisee
    return if reserved
    return if updated_at_was.present? && updated_at_was > 15.minutes.ago # Do not spam admin

    unless approved
      Pro::AppMailer.stylist_website_update_request_submitted(self).deliver
    end
  end

  def testimonials
    {
      testimonial_1:  testimonial_1&.attributes,
      testimonial_2:  testimonial_2&.attributes,
      testimonial_3:  testimonial_3&.attributes,
      testimonial_4:  testimonial_4&.attributes,
      testimonial_5:  testimonial_5&.attributes,
      testimonial_6:  testimonial_6&.attributes,
      testimonial_7:  testimonial_7&.attributes,
      testimonial_8:  testimonial_8&.attributes,
      testimonial_9:  testimonial_9&.attributes,
      testimonial_10: testimonial_10&.attributes
    }
  end

  def as_json(_options = {})
    super(methods: [:testimonials])
  end

  private

    def process_social_links
      SOCIAL_PREFIXES.each do |key, value|
        attr = "#{key}_url"
        next if send(attr).blank?

        send("#{attr}=", send(attr).delete('@'))
        unless send(attr).include?(value.gsub(%r{(http(s)?://(www.)?)}, ''))
          send("#{attr}=", "#{value}#{send(attr)}")
        end
      end
    end

    def auto_format_phone_number
      if phone_number.present?
        Rails.logger.debug { "yes phone number is present #{phone_number}" }
        self.phone_number = formatPhoneNumber(phone_number) # ActionController::Base.helpers.number_to_phone(self.phone_number.gsub(/\D/, ''), area_code: true, raise: true)
      else
        Rails.logger.debug { "NO no phone number present - #{phone_number}" }
      end
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
      Rollbar.error(e)
      Rails.logger.debug { "bad phone number format! #{e}" }
    end

    def formatPhoneNumber(s)
      return '' unless s

      s2 = s.to_s.gsub(/\D/, '')
      m = s2.match(/^(\d{3})(\d{3})(\d{4})$/)
      m ? "(#{m[1]}) #{m[2]}-#{m[3]}" : nil
    end

    def auto_orient_images
      Rails.logger.debug 'auto_orient_images!'
      if image_1_url_changed? && image_1_url.present?
        Rails.logger.debug 'image_1 changed yo'
        self.image_1 = open(image_1_url)
      end

      if image_2_url_changed? && image_2_url.present?
        self.image_2 = open(image_2_url)
      end

      if image_3_url_changed? && image_3_url.present?
        self.image_3 = open(image_3_url)
      end

      if image_4_url_changed? && image_4_url.present?
        self.image_4 = open(image_4_url)
      end

      if image_5_url_changed? && image_5_url.present?
        self.image_5 = open(image_5_url)
      end

      if image_6_url_changed? && image_6_url.present?
        self.image_6 = open(image_6_url)
      end

      if image_7_url_changed? && image_7_url.present?
        self.image_7 = open(image_7_url)
      end

      if image_8_url_changed? && image_8_url.present?
        self.image_8 = open(image_8_url)
      end

      if image_9_url_changed? && image_9_url.present?
        self.image_9 = open(image_9_url)
      end

      if image_10_url_changed? && image_10_url.present?
        self.image_10 = open(image_10_url)
      end
    end

    def email_stylist
      PublicWebsiteMailer.stylist_website_is_updated(self).deliver
    end

    def publish_if_approved
      if approved_was != true && approved == true
        publish_and_save
        email_stylist
      end
    end

    def reserve_stylist
      return unless reserved

      stylist.update_column(:reserved, true)
    end

    def remove_unwanted_text
      begin
        self.biography = self.biography.gsub("&nbsp;", " ")
      rescue
        nil
      end
    end
end

# == Schema Information
#
# Table name: update_my_sola_websites
#
#  id                    :integer          not null, primary key
#  approved              :boolean          default(FALSE)
#  barber                :boolean
#  biography             :text
#  booking_url           :string(255)
#  botox                 :boolean
#  brows                 :boolean
#  business_name         :string(255)
#  email_address         :string(255)
#  eyelash_extensions    :boolean
#  facebook_url          :string(255)
#  google_plus_url       :string(255)
#  hair                  :boolean
#  hair_extensions       :boolean
#  image_10_content_type :string(255)
#  image_10_file_name    :string(255)
#  image_10_file_size    :integer
#  image_10_updated_at   :datetime
#  image_10_url          :string(255)
#  image_1_content_type  :string(255)
#  image_1_file_name     :string(255)
#  image_1_file_size     :integer
#  image_1_updated_at    :datetime
#  image_1_url           :string(255)
#  image_2_content_type  :string(255)
#  image_2_file_name     :string(255)
#  image_2_file_size     :integer
#  image_2_updated_at    :datetime
#  image_2_url           :string(255)
#  image_3_content_type  :string(255)
#  image_3_file_name     :string(255)
#  image_3_file_size     :integer
#  image_3_updated_at    :datetime
#  image_3_url           :string(255)
#  image_4_content_type  :string(255)
#  image_4_file_name     :string(255)
#  image_4_file_size     :integer
#  image_4_updated_at    :datetime
#  image_4_url           :string(255)
#  image_5_content_type  :string(255)
#  image_5_file_name     :string(255)
#  image_5_file_size     :integer
#  image_5_updated_at    :datetime
#  image_5_url           :string(255)
#  image_6_content_type  :string(255)
#  image_6_file_name     :string(255)
#  image_6_file_size     :integer
#  image_6_updated_at    :datetime
#  image_6_url           :string(255)
#  image_7_content_type  :string(255)
#  image_7_file_name     :string(255)
#  image_7_file_size     :integer
#  image_7_updated_at    :datetime
#  image_7_url           :string(255)
#  image_8_content_type  :string(255)
#  image_8_file_name     :string(255)
#  image_8_file_size     :integer
#  image_8_updated_at    :datetime
#  image_8_url           :string(255)
#  image_9_content_type  :string(255)
#  image_9_file_name     :string(255)
#  image_9_file_size     :integer
#  image_9_updated_at    :datetime
#  image_9_url           :string(255)
#  instagram_url         :string(255)
#  laser_hair_removal    :boolean
#  linkedin_url          :string(255)
#  makeup                :boolean
#  massage               :boolean
#  microblading          :boolean
#  nails                 :boolean
#  name                  :string(255)
#  other_service         :string(255)
#  permanent_makeup      :boolean
#  phone_number          :string(255)
#  pinterest_url         :string(255)
#  reserved              :boolean          default(FALSE)
#  skin                  :boolean
#  tanning               :boolean
#  teeth_whitening       :boolean
#  testimonial_id_1      :integer
#  testimonial_id_10     :integer
#  testimonial_id_2      :integer
#  testimonial_id_3      :integer
#  testimonial_id_4      :integer
#  testimonial_id_5      :integer
#  testimonial_id_6      :integer
#  testimonial_id_7      :integer
#  testimonial_id_8      :integer
#  testimonial_id_9      :integer
#  threading             :boolean
#  tik_tok_url           :string
#  twitter_url           :string(255)
#  waxing                :boolean
#  website_url           :string(255)
#  work_hours            :text
#  yelp_url              :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  stylist_id            :integer
#
# Indexes
#
#  index_update_my_sola_websites_on_stylist_id  (stylist_id)
#
