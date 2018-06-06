class AddImageAndGeneratedImageToSola10kImage < ActiveRecord::Migration
  def change
  	add_attachment :sola10k_images, :image
  	add_attachment :sola10k_images, :generated_image
  end
end
