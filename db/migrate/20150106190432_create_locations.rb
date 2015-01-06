class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :url_name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :email_address_for_inquiries
      t.string :phone_number
      t.string :general_contact_name
      t.text :description
      t.string :facebook_url
      t.string :twitter_url
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
