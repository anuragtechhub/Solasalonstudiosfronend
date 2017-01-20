class ChangeExpressionToStatementForMySolaImages < ActiveRecord::Migration
  def change
    rename_column :my_sola_images, :expression, :statement
  end
end
