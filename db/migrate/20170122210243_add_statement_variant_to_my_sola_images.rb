class AddStatementVariantToMySolaImages < ActiveRecord::Migration
  def change
    add_column :my_sola_images, :statement_variant, :string
  end
end
