# TODO: we should unify SolaStylist and Stylist across all applications
class SolaStylist < Stylist
  self.table_name = 'stylists'
end

# == Schema Information
#
# Table name: stylists
#
#  id                             :integer          not null, primary key
#  accepting_new_clients          :boolean          default(TRUE)
#  biography                      :text
#  booking_url                    :string(255)
#  botox                          :boolean
#  brows                          :boolean
#  business_name                  :string(255)
#  city                           :string(255)
#  cosmetology_license_date       :date
#  cosmetology_license_number     :string(255)
#  country                        :string(255)
#  current_sign_in_at             :datetime
#  current_sign_in_ip             :inet
#  date_of_birth                  :date
#  electronic_license_agreement   :boolean          default(FALSE)
#  email_address                  :citext           not null
#  emergency_contact_name         :string(255)
#  emergency_contact_phone_number :string(255)
#  emergency_contact_relationship :string(255)
#  encrypted_password             :string(255)      default("")
#  eyelash_extensions             :boolean
#  facebook_url                   :string(255)
#  force_show_book_now_button     :boolean          default(FALSE)
#  google_plus_url                :string(255)
#  hair                           :boolean
#  hair_extensions                :boolean
#  image_10_alt_text              :text
#  image_10_content_type          :string(255)
#  image_10_file_name             :string(255)
#  image_10_file_size             :integer
#  image_10_updated_at            :datetime
#  image_1_alt_text               :text
#  image_1_content_type           :string(255)
#  image_1_file_name              :string(255)
#  image_1_file_size              :integer
#  image_1_updated_at             :datetime
#  image_2_alt_text               :text
#  image_2_content_type           :string(255)
#  image_2_file_name              :string(255)
#  image_2_file_size              :integer
#  image_2_updated_at             :datetime
#  image_3_alt_text               :text
#  image_3_content_type           :string(255)
#  image_3_file_name              :string(255)
#  image_3_file_size              :integer
#  image_3_updated_at             :datetime
#  image_4_alt_text               :text
#  image_4_content_type           :string(255)
#  image_4_file_name              :string(255)
#  image_4_file_size              :integer
#  image_4_updated_at             :datetime
#  image_5_alt_text               :text
#  image_5_content_type           :string(255)
#  image_5_file_name              :string(255)
#  image_5_file_size              :integer
#  image_5_updated_at             :datetime
#  image_6_alt_text               :text
#  image_6_content_type           :string(255)
#  image_6_file_name              :string(255)
#  image_6_file_size              :integer
#  image_6_updated_at             :datetime
#  image_7_alt_text               :text
#  image_7_content_type           :string(255)
#  image_7_file_name              :string(255)
#  image_7_file_size              :integer
#  image_7_updated_at             :datetime
#  image_8_alt_text               :text
#  image_8_content_type           :string(255)
#  image_8_file_name              :string(255)
#  image_8_file_size              :integer
#  image_8_updated_at             :datetime
#  image_9_alt_text               :text
#  image_9_content_type           :string(255)
#  image_9_file_name              :string(255)
#  image_9_file_size              :integer
#  image_9_updated_at             :datetime
#  inactive_reason                :integer
#  instagram_url                  :string(255)
#  laser_hair_removal             :boolean
#  last_sign_in_at                :datetime
#  last_sign_in_ip                :inet
#  linkedin_url                   :string(255)
#  location_name                  :string(255)
#  makeup                         :boolean
#  massage                        :boolean
#  microblading                   :boolean
#  msa_name                       :string(255)
#  nails                          :boolean
#  name                           :string(255)
#  onboarded                      :boolean          default(FALSE), not null
#  other_service                  :string(255)
#  permanent_makeup               :boolean
#  permitted_use_for_studio       :string(255)
#  phone_number                   :string(255)
#  phone_number_display           :boolean          default(TRUE)
#  pinterest_url                  :string(255)
#  postal_code                    :string(255)
#  remember_created_at            :datetime
#  reserved                       :boolean          default(FALSE)
#  reset_password_sent_at         :datetime
#  reset_password_token           :string(255)
#  send_a_message_button          :boolean          default(TRUE)
#  sg_booking_url                 :string(255)
#  sign_in_count                  :integer          default(0), not null
#  skin                           :boolean
#  sola_genius_enabled            :boolean          default(TRUE)
#  sola_pro_platform              :string(255)
#  sola_pro_version               :string(255)
#  solagenius_account_created_at  :datetime
#  state_province                 :string(255)
#  status                         :string(255)
#  street_address                 :string(255)
#  studio_number                  :string(255)
#  tanning                        :boolean
#  teeth_whitening                :boolean
#  testimonial_id_1               :integer
#  testimonial_id_10              :integer
#  testimonial_id_2               :integer
#  testimonial_id_3               :integer
#  testimonial_id_4               :integer
#  testimonial_id_5               :integer
#  testimonial_id_6               :integer
#  testimonial_id_7               :integer
#  testimonial_id_8               :integer
#  testimonial_id_9               :integer
#  threading                      :boolean
#  total_booknow_bookings         :integer
#  total_booknow_revenue          :string(255)
#  twitter_url                    :string(255)
#  url_name                       :string(255)
#  walkins                        :boolean
#  walkins_expiry                 :datetime
#  waxing                         :boolean
#  website_email_address          :string(255)
#  website_name                   :string(255)
#  website_phone_number           :string(255)
#  website_url                    :string(255)
#  work_hours                     :text
#  yelp_url                       :string(255)
#  created_at                     :datetime
#  updated_at                     :datetime
#  legacy_id                      :string(255)
#  location_id                    :integer
#  rent_manager_id                :string(255)
#
# Indexes
#
#  index_stylists_on_email_address           (email_address)
#  index_stylists_on_location_id             (location_id)
#  index_stylists_on_location_id_and_status  (location_id,status)
#  index_stylists_on_reset_password_token    (reset_password_token) UNIQUE
#  index_stylists_on_status                  (status)
#  index_stylists_on_url_name                (url_name)
#
