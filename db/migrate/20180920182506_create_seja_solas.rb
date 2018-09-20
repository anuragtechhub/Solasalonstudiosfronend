class CreateSejaSolas < ActiveRecord::Migration
  def change
    create_table :seja_solas do |t|
      t.string :nome
      t.string :email
      t.string :telefone

      t.timestamps
    end
  end
end
