class AddOtherServiceToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :other_service, :string
  end
end
