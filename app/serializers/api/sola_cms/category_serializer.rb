# frozen_string_literal: true

class Api::SolaCms::CategorySerializer < ApplicationSerializer
  attributes :id, :name, :slug, :created_at, :updated_at
end
