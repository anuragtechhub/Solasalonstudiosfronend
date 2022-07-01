# frozen_string_literal: true

class GlossGeniusLog < ActiveRecord::Base
  self.table_name = :gloss_genius_logs
  include PgSearch::Model
  pg_search_scope :search_by_action_name_and_host, against: [:action_name, :host],
  using: {
    tsearch: {
      prefix: true,
      any_word: true
    }
  }
end
