# frozen_string_literal: true

module Pro
  class Api::V4::UsersController < Api::V4::ApiController

    def current
      serializer = current_user.is_a?(Admin) ? Api::V4::AdminSerializer : Api::V4::UserSerializer
      respond_with(current_user, serializer: serializer, root: 'user')
    end
  end
end
