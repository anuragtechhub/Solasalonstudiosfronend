# frozen_string_literal: true

module Pro
  class Api::V3::SavedSearchSerializer < ApplicationSerializer
    attributes :query, :kind, :updated_at
  end
end
