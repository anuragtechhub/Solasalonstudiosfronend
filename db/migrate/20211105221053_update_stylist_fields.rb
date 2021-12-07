class UpdateStylistFields < ActiveRecord::Migration
  def change
    WatchLater.where(userable_type: 'SolaStylist').update_all(userable_type: 'Stylist')
    VideoView.where(userable_type: 'SolaStylist').update_all(userable_type: 'Stylist')
    UserNotification.where(userable_type: 'SolaStylist').update_all(userable_type: 'Stylist')
    Taggable.where(item_type: 'SolaStylist').update_all(item_type: 'Stylist')
    ResetPassword.where(userable_type: 'SolaStylist').update_all(userable_type: 'Stylist')
    PgSearchDocument.where(searchable_type: 'SolaStylist').update_all(searchable_type: 'Stylist')
    Event.where(userable_type: 'SolaStylist').update_all(userable_type: 'Stylist')
    Device.where(userable_type: 'SolaStylist').update_all(userable_type: 'Stylist')
    Categoriable.where(item_type: 'SolaStylist').update_all(item_type: 'Stylist')
    Brandable.where(item_type: 'SolaStylist').update_all(item_type: 'Stylist')
    rename_column :user_access_tokens, :sola_stylist_id, :stylist_id
    rename_column :saved_searches, :sola_stylist_id, :stylist_id
    rename_column :saved_items, :sola_stylist_id, :stylist_id
  end
end
