class CreateStylistMessages < ActiveRecord::Migration
  def change
    create_table :stylist_messages do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.text :message
      t.references :stylist, index: true

      t.timestamps
    end
  end
end
