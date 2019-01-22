class AddAreaDeAtuacaoToSejasola < ActiveRecord::Migration
  def change
  	unless ActiveRecord::Base.connection.column_exists?('seja_solas', 'area_de_atuacao')
    	add_column :seja_solas, :area_de_atuacao, :string
  	end
  end
end
