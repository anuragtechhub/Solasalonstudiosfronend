class AddAreaDeAtuacaoToSejasola < ActiveRecord::Migration
  def change
    add_column :seja_solas, :area_de_atuacao, :string
  end
end
