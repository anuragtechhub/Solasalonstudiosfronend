class ChangeSolaGeniusEnabledDefaultValue < ActiveRecord::Migration
  def change
    change_column_default :stylists, :sola_genius_enabled, true
  end
end
