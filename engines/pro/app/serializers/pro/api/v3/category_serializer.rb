module Pro
  class Api::V3::CategorySerializer < ApplicationSerializer
    attributes :id, :name, :slug
  end
end