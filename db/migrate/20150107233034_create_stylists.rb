class CreateStylists < ActiveRecord::Migration
  def change
    create_table :stylists do |t|
      t.string :name
      t.string :url_name
      t.text :biography
      t.string :email_address
      t.string :phone_number
      t.string :studio_number
      t.text :work_hours
      t.string :website
      t.string :business_name
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
      t.boolean :accepting_new_clients
      t.string :booking_url

      t.timestamps
    end
  end
end
