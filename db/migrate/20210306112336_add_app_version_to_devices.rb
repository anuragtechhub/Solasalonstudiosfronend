class AddAppVersionToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :app_version, :string
  end
end
