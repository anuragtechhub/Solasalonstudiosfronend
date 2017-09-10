class CreateStudios < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists? 'studios'
      create_table :studios do |t|
        t.string :name
        t.string :rent_manager_id, index: true
        t.references :stylist, index: true

        t.timestamps
      end
    end
  end
end
