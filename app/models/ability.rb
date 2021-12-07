# frozen_string_literal: true

module Ability
  class << self
    def new(user = nil)
      case user
      when ::Admin
        Ability::Admin.new(user)
      when ::Stylist
        Ability::Stylist.new(user)
      end
    end
  end
end
