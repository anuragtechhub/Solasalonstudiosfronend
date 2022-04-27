# frozen_string_literal: true

module Pro
  class Api::V3::SavedItemsController < Api::V3::ApiController
    def index
      respond_with(current_user.saved_items, include: '**')
    end

    # create/destroy
    def create
      saved_item = current_user.saved_items.find_by(item_type: params[:item_type], item_id: params[:item_id])

      if saved_item.present?
        saved_item.destroy
      else
        item = params[:item_type].constantize.find(params[:item_id])
        saved_item = current_user.saved_items.create(item: item)
      end

      respond_with :api, :v3, saved_item, include: '**'
    end
  end
end
