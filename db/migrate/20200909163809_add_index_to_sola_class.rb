class AddIndexToSolaClass < ActiveRecord::Migration
  def change
    add_index :sola_classes, :end_date
  end
end
