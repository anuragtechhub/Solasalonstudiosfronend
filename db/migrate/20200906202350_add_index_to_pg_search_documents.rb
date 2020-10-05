class AddIndexToPgSearchDocuments < ActiveRecord::Migration
  def change
    add_index :pg_search_documents, :content, order: {name: :text_pattern_ops}
  end
end
