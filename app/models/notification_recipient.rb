class NotificationRecipient < ActiveRecord::Base
  belongs_to :notification
  belongs_to :stylist
end
