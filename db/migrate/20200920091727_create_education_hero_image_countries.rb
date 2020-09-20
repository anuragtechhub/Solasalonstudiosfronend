class CreateEducationHeroImageCountries < ActiveRecord::Migration
  def change
    create_table :education_hero_image_countries do |t|
      t.references :country, index: true
      t.references :education_hero_image, index: true

      t.timestamps
    end
  end
end
