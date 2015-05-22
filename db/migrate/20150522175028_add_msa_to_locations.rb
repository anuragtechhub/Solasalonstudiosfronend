class AddMsaToLocations < ActiveRecord::Migration
  def change
    add_reference :locations, :msa, index: true
  end
end
