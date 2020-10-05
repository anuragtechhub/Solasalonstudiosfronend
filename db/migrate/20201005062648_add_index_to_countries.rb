class AddIndexToCountries < ActiveRecord::Migration
  def change
    add_index :countries, :code
  end
end
