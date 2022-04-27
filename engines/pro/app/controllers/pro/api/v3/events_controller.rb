# frozen_string_literal: true

module Pro
  class Api::V3::EventsController < Api::V3::ApiController
    def create
      respond_with(Event.create(event_params), location: nil)
    end

    private

      def event_params
        params.require(:event)
          .permit(:category, :action, :value, :source,
                  :platform, :brand_id, :video_id, :tool_id,
                  :sola_class_id, :deal_id).tap do |permitted|
          # set current user
          permitted[:userable] = current_user
        end
      end
  end
end
