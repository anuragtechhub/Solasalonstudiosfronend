# frozen_string_literal: true

module Pro
  class Api::V3::SavedItemSerializer < ApplicationSerializer
    attributes :id, :item_id, :item_type

    attribute :persisted do
      object.persisted?
    end

    belongs_to :item
  end
end
