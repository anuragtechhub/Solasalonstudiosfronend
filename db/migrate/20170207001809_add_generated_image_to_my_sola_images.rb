class AddGeneratedImageToMySolaImages < ActiveRecord::Migration
  def change
    add_attachment :my_sola_images, :generated_image
  end
end
