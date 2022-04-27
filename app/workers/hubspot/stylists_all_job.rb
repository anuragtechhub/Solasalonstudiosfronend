# frozen_string_literal: true

module Hubspot
  class StylistsAllJob < ::Hubspot::MainJob
    def perform
      Stylist.open.find_each do |stylist|
        stylist.sync_with_hubspot('hubspot')
      end
    end
  end
end
