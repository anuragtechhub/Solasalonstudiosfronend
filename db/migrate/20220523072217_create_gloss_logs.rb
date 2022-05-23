class CreateGlossLogs < ActiveRecord::Migration
  def change
    create_table :gloss_genius_logs do |t|
      t.string :action_name
      t.string :ip_address
      t.string :host
      t.jsonb :request_body
      t.timestamps
    end
  end
end
