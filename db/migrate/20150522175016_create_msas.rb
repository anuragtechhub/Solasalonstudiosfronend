class CreateMsas < ActiveRecord::Migration
  def change
    create_table :msas do |t|
      t.string :name
      t.string :url_name
      t.string :legacy_id
      t.text :text

      t.timestamps
    end
  end
end
