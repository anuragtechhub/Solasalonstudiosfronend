class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :api_key

      t.timestamps
    end
  end
end
