module Pro
	class Api::V3::LocationSerializer < ApplicationSerializer
    attributes :id, :name, :country, :walkins_enabled, :max_walkins_time
  end
end