class CreateTerminatedStylists < ActiveRecord::Migration
  def change
    create_table :terminated_stylists do |t|
      t.datetime :stylist_created_at
      t.string :name
      t.string :email_address
      t.string :phone_number
      t.string :studio_number
      t.references :location, index: true

      t.timestamps
    end
  end
end
