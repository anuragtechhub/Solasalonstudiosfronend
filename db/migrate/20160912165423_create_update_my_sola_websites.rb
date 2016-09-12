class CreateUpdateMySolaWebsites < ActiveRecord::Migration
  def change
    create_table :update_my_sola_websites do |t|
      t.string :name
      t.string :biography
      t.string :phone_number
      t.string :business_name
      t.text :work_hours
      t.boolean :hair
      t.boolean :skin
      t.boolean :nails
      t.boolean :massage
      t.boolean :teeth_whitening
      t.boolean :eyelash_extensions
      t.boolean :makeup
      t.boolean :tanning
      t.boolean :waxing
      t.boolean :brows
      t.string :website_url
      t.string :booking_url
      t.string :pinterest_url
      t.string :facebook_url
      t.string :twitter_url
      t.string :instagram_url
      t.string :yelp_url
      t.boolean :laser_hair_removal
      t.boolean :threading
      t.boolean :permament_makeup
      t.string :other_service
      t.string :google_plus_url
      t.string :linkedin_url
      t.boolean :hair_extensions
      t.integer :testimonial_id_1
      t.integer :testimonial_id_2
      t.integer :testimonial_id_3
      t.integer :testimonial_id_4
      t.integer :testimonial_id_5
      t.integer :testimonial_id_6
      t.integer :testimonial_id_7
      t.integer :testimonial_id_8
      t.integer :testimonial_id_9
      t.integer :testimonial_id_10
      t.string :image_1_url
      t.string :image_2_url
      t.string :image_3_url
      t.string :image_4_url
      t.string :image_5_url
      t.string :image_6_url
      t.string :image_7_url
      t.string :image_8_url
      t.string :image_9_url
      t.string :image_10_url

      t.timestamps
    end
  end
end
