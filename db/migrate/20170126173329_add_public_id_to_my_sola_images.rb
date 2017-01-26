class AddPublicIdToMySolaImages < ActiveRecord::Migration
  def change
    add_column :my_sola_images, :public_id, :string
  end
end
