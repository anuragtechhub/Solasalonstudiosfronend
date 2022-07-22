class RenameStylistMiddleNameToMName < ActiveRecord::Migration
  def change
    rename_column :stylists, :middle_name, :m_name
  end
end
