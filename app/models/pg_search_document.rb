# frozen_string_literal: true

class PgSearchDocument < ActiveRecord::Base
end

# == Schema Information
#
# Table name: pg_search_documents
#
#  id              :integer          not null, primary key
#  content         :text
#  searchable_id   :integer
#  searchable_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_pg_search_documents_on_content                            (content)
#  index_pg_search_documents_on_searchable_id_and_searchable_type  (searchable_id,searchable_type)
#
