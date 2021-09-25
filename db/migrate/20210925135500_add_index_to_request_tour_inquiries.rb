class AddIndexToRequestTourInquiries < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_index :request_tour_inquiries, :email, algorithm: :concurrently
    enable_extension 'pg_trgm'
    execute "CREATE INDEX CONCURRENTLY index_blogs_on_title_trigram ON blogs USING gin(title gin_trgm_ops);"
    execute "CREATE INDEX CONCURRENTLY index_blogs_on_body_trigram ON blogs USING gin(body gin_trgm_ops);"
    execute "CREATE INDEX CONCURRENTLY index_blogs_on_author_trigram ON blogs USING gin(author gin_trgm_ops);"
  end
end
