class CreateSejaSolas < ActiveRecord::Migration
  def change
  	unless ActiveRecord::Base.connection.table_exists?('seja_solas')
	    create_table :seja_solas do |t|
	      t.string :nome
	      t.string :email
	      t.string :telefone

	      t.timestamps
	    end
	  end
  end
end
