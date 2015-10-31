class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.string :ip_address
      t.string :user_agent_string
      t.string :uuid

      t.timestamps
    end
  end
end
