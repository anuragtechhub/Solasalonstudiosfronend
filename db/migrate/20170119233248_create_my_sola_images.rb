class CreateMySolaImages < ActiveRecord::Migration
  def change
    create_table :my_sola_images do |t|
      t.string :name
      t.string :instagram_handle
      t.text :expression
      t.boolean :approved, :default => false
      t.datetime :approved_at
      t.attachment :image

      t.timestamps
    end
  end
end
