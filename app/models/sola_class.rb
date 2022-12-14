# frozen_string_literal: true

class SolaClass < ActiveRecord::Base
  include PgSearch::Model

  pg_search_scope :search, against: %i[title description sola_class_region_id state city address location start_date end_date], associated_against: {
    category: [:name]
  }
  multisearchable against: [:stripped_title], if: ->(record) { record.end_date.present? && record.end_date >= Date.current }

  before_validation :auto_set_country, :save_region
  before_create :save_admin
  after_create :send_notifications
  after_save :touch_brands

  belongs_to :sola_class_category
  belongs_to :sola_class_region

  belongs_to :category
  # belongs_to :brand
  belongs_to :admin
  belongs_to :video

  belongs_to :class_image, class_name: 'ClassImage', primary_key: :id, inverse_of: :sola_classes

  has_and_belongs_to_many :brands

  has_many :taggables, as: :item, dependent: :destroy
  has_many :tags, through: :taggables

  has_many :notifications, dependent: :destroy

  has_many :sola_class_countries
  has_many :countries, through: :sola_class_countries
  has_many :events, dependent: :destroy

  # after_validation :geocode, :reverse_geocode
  # geocoded_by :city_state
  # reverse_geocoded_by :latitude, :longitude do |obj, results|
  #   if geo = results.first
  #     obj.city = geo.city
  #     obj.state = geo.state
  #   end
  # end

  has_paper_trail

  has_attached_file :image, path: ':class/:attachment/:id_partition/:style/:filename', styles: { full_width: '960>', large: '460x280#', small: '300x180#' }, s3_protocol: :https
  validates_attachment :image, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }
  attr_accessor :delete_image, :delete_file

  before_validation { image.destroy if delete_image == '1' }

  has_attached_file :file, path: ':class/:attachment/:id_partition/:style/:filename', s3_protocol: :https
  validates_attachment :file, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif', 'text/plain', 'text/html', 'application/msword', 'application/vnd.ms-works', 'application/rtf', 'application/pdf', 'application/vnd.ms-powerpoint', 'application/x-compress', 'application/x-compressed', 'application/x-gzip', 'application/zip', 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'text/csv', 'text/tab-separated-values'] }

  before_validation { file.destroy if delete_file == '1' }

  validates :title, length: { maximum: 35 }, presence: true
  validates :city, length: { maximum: 40 }, presence: true, if: :not_webinars
  validates :state, length: { maximum: 40 }, presence: true, if: :not_webinars
  validates :sola_class_region, presence: true
  validates :description, length: { maximum: 400 }, presence: true
  validates :cost, length: { maximum: 40 }
  validates :location, length: { maximum: 40 }, presence: true, if: :not_webinars
  validates :link_url, url: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_is_after_start_date
  # validates :countries, :presence => true

  scope :upcoming, -> { where('end_date >= ?', Date.current) }

  def stripped_title
    title&.strip
  end

  def city_state
    "#{city}, #{state}"
  end

  def label
    "#{title} (#{city})"
  end

  def class_image_name
    class_image ? class_image.name : ''
  end 

  def abbreviation_to_state(abbrev = nil)
    return nil unless abbrev

    abbreviations = {
      'AL' => 'Alabama',
      'AK' => 'Alaska',
      'AS' => 'America Samoa',
      'AZ' => 'Arizona',
      'AR' => 'Arkansas',
      'CA' => 'California',
      'CO' => 'Colorado',
      'CT' => 'Connecticut',
      'DE' => 'Delaware',
      'DC' => 'District of Columbia',
      'FM' => 'Federated States Of Micronesia',
      'FL' => 'Florida',
      'GA' => 'Georgia',
      'GU' => 'Guam',
      'HI' => 'Hawaii',
      'ID' => 'Idaho',
      'IL' => 'Illinois',
      'IN' => 'Indiana',
      'IA' => 'Iowa',
      'KS' => 'Kansas',
      'KY' => 'Kentucky',
      'LA' => 'Louisiana',
      'ME' => 'Maine',
      'MH' => 'Marshall Islands',
      'MD' => 'Maryland',
      'MA' => 'Massachusetts',
      'MI' => 'Michigan',
      'MN' => 'Minnesota',
      'MS' => 'Mississippi',
      'MO' => 'Missouri',
      'MT' => 'Montana',
      'NE' => 'Nebraska',
      'NV' => 'Nevada',
      'NH' => 'New Hampshire',
      'NJ' => 'New Jersey',
      'NM' => 'New Mexico',
      'NY' => 'New York',
      'NC' => 'North Carolina',
      'ND' => 'North Dakota',
      'OH' => 'Ohio',
      'OK' => 'Oklahoma',
      'OR' => 'Oregon',
      'PW' => 'Palau',
      'PA' => 'Pennsylvania',
      'PR' => 'Puerto Rico',
      'RI' => 'Rhode Island',
      'SC' => 'South Carolina',
      'SD' => 'South Dakota',
      'TN' => 'Tennessee',
      'TX' => 'Texas',
      'UT' => 'Utah',
      'VT' => 'Vermont',
      'VI' => 'Virgin Island',
      'VA' => 'Virginia',
      'WA' => 'Washington',
      'WV' => 'West Virginia',
      'WI' => 'Wisconsin',
      'WY' => 'Wyoming',
      'ON' => 'Ontario'
    }

    abbreviations[abbrev]
  end

  # def state_enum
  #   [
  #     ['Alabama', 'Alabama'],
  #     ['Alaska', 'Alaska'],
  #     ['Arizona', 'Arizona'],
  #     ['Arkansas', 'Arkansas'],
  #     ['California', 'California'],
  #     ['Colorado', 'Colorado'],
  #     ['Connecticut', 'Connecticut'],
  #     ['Delaware', 'Delaware'],
  #     ['District of Columbia', 'District of Columbia'],
  #     ['Florida', 'Florida'],
  #     ['Georgia', 'Georgia'],
  #     ['Hawaii', 'Hawaii'],
  #     ['Idaho', 'Idaho'],
  #     ['Illinois', 'Illinois'],
  #     ['Indiana', 'Indiana'],
  #     ['Iowa', 'Iowa'],
  #     ['Kansas', 'Kansas'],
  #     ['Kentucky', 'Kentucky'],
  #     ['Louisiana', 'Louisiana'],
  #     ['Maine', 'Maine'],
  #     ['Maryland', 'Maryland'],
  #     ['Massachusetts', 'Massachusetts'],
  #     ['Michigan', 'Michigan'],
  #     ['Minnesota', 'Minnesota'],
  #     ['Mississippi', 'Mississippi'],
  #     ['Missouri', 'Missouri'],
  #     ['Montana', 'Montana'],
  #     ['Nebraska', 'Nebraska'],
  #     ['Nevada', 'Nevada'],
  #     ['New Hampshire', 'New Hampshire'],
  #     ['New Jersey', 'New Jersey'],
  #     ['New Mexico', 'New Mexico'],
  #     ['New York', 'New York'],
  #     ['North Carolina', 'North Carolina'],
  #     ['North Dakota', 'North Dakota'],
  #     ['Ohio', 'Ohio'],
  #     ['Oklahoma', 'Oklahoma'],
  #     ['Oregon', 'Oregon'],
  #     ['Pennsylvania', 'Pennsylvania'],
  #     ['Rhode Island', 'Rhode Island'],
  #     ['South Carolina', 'South Carolina'],
  #     ['South Dakota', 'South Dakota'],
  #     ['Tennessee', 'Tennessee'],
  #     ['Texas', 'Texas'],
  #     ['Utah', 'Utah'],
  #     ['Vermont', 'Vermont'],
  #     ['Virginia', 'Virginia'],
  #     ['Washington', 'Washington'],
  #     ['West Virginia', 'West Virginia'],
  #     ['Wisconsin', 'Wisconsin'],
  #     ['Wyoming', 'Wyoming']
  #   ]
  # end

  def to_param
    title.gsub(' ', '-')
  end

  def is_featured_enum
    [['Yes', true], ['No', false]]
  end

  def category_name
    category&.name
  end

  def region
    sola_class_region
  end

  def brand_name
    brand&.name
  end

  def brand_id
    brand&.id
  end

  def file_url
    file.url if file&.present?
  end

  def brand
    brands.first if brands&.size&.positive?
  end



  def tag
    self.tags&.map{ | a| {id: a.id, name: a.name} }
  end

  def as_json(_options = {})
    super(except: %i[ image file], methods: %i[brand_id brand_name tag class_image_name category category_name region file_url link_url video], include: {brands: {only: [:name, :id]}})
  end

  private

    def auto_set_country
      if Admin&.current && Admin.current.id && Admin.current.franchisee && Admin.current.sola_pro_country_admin.present?
        country = Country.where(code: Admin.current.sola_pro_country_admin)
        if country && countries.none? { |c| c.code == Admin.current.sola_pro_country_admin }
          countries << country
        end
      end
    end

    def not_webinars
      sola_class_region && sola_class_region.name != 'Webinars' && sola_class_region.name != 'Past Webinars'
    end

    def send_notifications
      Pro::AppMailer.new_class_or_event(self).deliver
    end

    def touch_brands
      brands.each(&:touch)
    end

    def save_region
      if state.length == 2
        self.state = abbreviation_to_state(state.upcase)
      end

      Rails.logger.debug { "save_region self.state=#{state}" }
      region_state = SolaClassRegionState.where('LOWER(state) = ?', state.downcase).first
      Rails.logger.debug { "region_state=#{region_state}" }
      self.sola_class_region = region_state.sola_class_region if region_state&.sola_class_region
      Rails.logger.debug { "self.sola_class_region=#{sola_class_region.inspect}" }
    end

    def save_admin
      if Admin&.current && Admin.current.id
        self.admin_id = Admin.current.id
      end
    end

    def end_date_is_after_start_date
      if end_date && start_date && end_date < start_date
        errors[:base] << 'End date cannot be before the start date'
      end
    end
end

# == Schema Information
#
# Table name: sola_classes
#
#  id                     :integer          not null, primary key
#  address                :string(255)
#  city                   :string(255)
#  cost                   :string(255)
#  description            :text
#  end_date               :date
#  end_time               :text
#  file_content_type      :string(255)
#  file_file_name         :string(255)
#  file_file_size         :integer
#  file_text              :string(255)
#  file_updated_at        :datetime
#  image_content_type     :string(255)
#  image_file_name        :string(255)
#  image_file_size        :integer
#  image_updated_at       :datetime
#  is_featured            :boolean          default(FALSE)
#  latitude               :float
#  link_text              :string(255)
#  link_url               :string(255)
#  location               :string(255)
#  longitude              :float
#  postal_code            :string(255)
#  rsvp_email_address     :string(255)
#  rsvp_phone_number      :string(255)
#  start_date             :date
#  start_time             :text
#  state                  :string(255)
#  title                  :string(255)
#  views                  :integer          default(0), not null
#  created_at             :datetime
#  updated_at             :datetime
#  admin_id               :integer
#  category_id            :integer
#  class_image_id         :integer
#  sola_class_category_id :integer
#  sola_class_region_id   :integer
#  video_id               :integer
#
# Indexes
#
#  index_sola_classes_on_admin_id                (admin_id)
#  index_sola_classes_on_category_id             (category_id)
#  index_sola_classes_on_end_date                (end_date)
#  index_sola_classes_on_sola_class_category_id  (sola_class_category_id)
#  index_sola_classes_on_sola_class_region_id    (sola_class_region_id)
#  index_sola_classes_on_video_id                (video_id)
#  index_sola_classes_on_views                   (views DESC)
#