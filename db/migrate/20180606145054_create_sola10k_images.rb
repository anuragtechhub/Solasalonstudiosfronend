class CreateSola10kImages < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists?('sola10k_images')
      create_table :sola10k_images do |t|
        t.string :name
        t.string :instagram_handle
        t.text :statement
        t.boolean :approved
        t.datetime :approved_at
        t.string :public_id

        t.timestamps
      end
    end
  end
end
