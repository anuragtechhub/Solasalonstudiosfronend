class CreateMozs < ActiveRecord::Migration
  def change
    create_table :mozs do |t|
      t.string :token

      t.timestamps
    end
  end
end
