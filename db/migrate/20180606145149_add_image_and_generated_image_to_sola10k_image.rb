class AddImageAndGeneratedImageToSola10kImage < ActiveRecord::Migration
  def change
  	unless ActiveRecord::Base.connection.column_exists?('sola10k_images', 'image_file_name')
	  	add_attachment :sola10k_images, :image
	  	add_attachment :sola10k_images, :generated_image
  	end
  end
end
