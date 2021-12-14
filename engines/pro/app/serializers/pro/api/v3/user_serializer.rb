module Pro
  class Api::V3::UserSerializer < ApplicationSerializer
    attributes :id, :name, :email_address,
               :phone_number, :business_name, :website_name,
               :biography, :booking_url, :reserved,
               :pinterest_url, :linkedin_url, :facebook_url,
               :twitter_url, :instagram_url, :yelp_url, :tik_tok_url, :onboarded,
               :barber, :botox, :brows, :hair, :hair_extensions, :laser_hair_removal,
               :makeup, :massage, :microblading, :nails, :permanent_makeup,
               :threading, :eyelash_extensions, :teeth_whitening, :tanning,
               :waxing, :walkins, :walkins_expiry, :skin, :other_service, :work_hours,
               :sola_pro_platform, :sola_pro_version, :website_url
    attribute :video_history_data
    attribute :app_settings
    attribute :my_sola_website
    attribute(:class_name) { object.class.name }

    # TMP hack
    attribute(:image_1_url) { object.image_1_url.presence || '/image_1s/original/missing.png' }
    attribute(:image_2_url) { object.image_2_url.presence || '/image_2s/original/missing.png' }
    attribute(:image_3_url) { object.image_3_url.presence || '/image_3s/original/missing.png' }
    attribute(:image_4_url) { object.image_4_url.presence || '/image_4s/original/missing.png' }
    attribute(:image_5_url) { object.image_5_url.presence || '/image_5s/original/missing.png' }
    attribute(:image_6_url) { object.image_6_url.presence || '/image_6s/original/missing.png' }
    attribute(:image_7_url) { object.image_7_url.presence || '/image_7s/original/missing.png' }
    attribute(:image_8_url) { object.image_8_url.presence || '/image_8s/original/missing.png' }
    attribute(:image_9_url) { object.image_9_url.presence || '/image_9s/original/missing.png' }
    attribute(:image_10_url) { object.image_10_url.presence || '/image_10s/original/missing.png' }

    has_many :brands
    # has_many :tags
    has_many :categories

    belongs_to :location

    belongs_to :testimonial_1
    belongs_to :testimonial_2
    belongs_to :testimonial_3
    belongs_to :testimonial_4
    belongs_to :testimonial_5
    belongs_to :testimonial_6
    belongs_to :testimonial_7
    belongs_to :testimonial_8
    belongs_to :testimonial_9
    belongs_to :testimonial_10

    %w[instagram facebook twitter yelp linkedin pinterest].each do |key|
      attr = "#{key}_url"
      url = UpdateMySolaWebsite::SOCIAL_PREFIXES[key.to_sym].
        gsub(%r{(http(s)?\:\/\/(www.)?)},'').
        gsub('/','\/')
      define_method(attr) do
        object.send(attr).to_s.
          gsub(%r{(http(s)?:\/\/(www.)?#{url})}, '')
      end
    end
  end
end
