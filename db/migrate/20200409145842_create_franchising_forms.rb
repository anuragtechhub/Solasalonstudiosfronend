class CreateFranchisingForms < ActiveRecord::Migration
  def change
    create_table :franchising_forms do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_address
      t.string :phone_number
      t.boolean :multi_unit_operator
      t.string :liquid_capital
      t.string :city
      t.string :state
      t.boolean :agree_to_receive_email

      t.timestamps
    end unless table_exists?(:franchising_forms)
  end
end
