# frozen_string_literal: true

module Pro
  class Api::V2::EventsController < ApiController
    def save
      userable = get_user(params[:email])

      event = Event.create({
                             category:      params[:category],
                             action:        params[:action_param],
                             value:         params[:value],
                             source:        params[:source],
                             platform:      params[:platform],
                             brand_id:      params[:brand_id],
                             video_id:      params[:video_id],
                             tool_id:       params[:tool_id],
                             sola_class_id: params[:sola_class_id],
                             deal_id:       params[:deal_id],
                             userable_id:   userable ? userable.id : nil,
                             userable_type: userable ? userable.class.name : nil
                           })

      p "created event=#{event.inspect}"

      render json: { success: true }
    end
  end
end
