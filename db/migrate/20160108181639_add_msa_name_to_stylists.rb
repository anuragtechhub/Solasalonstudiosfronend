class AddMsaNameToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :msa_name, :string
  end
end
