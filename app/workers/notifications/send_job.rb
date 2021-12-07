module Notifications
  class SendJob
    include Sidekiq::Worker

    def perform(type, notification_id=nil, user_id=nil)
      if type == 'send'
        @notification = Notification.find notification_id

        return if @notification.date_sent.present?
        return if @notification.notification_text.blank?

        create_in_app_notifications(Stylist)
        create_in_app_notifications(Admin) unless @notification.stylists.exists?
        # stub_responses - parameter which determines
        # if we creating fake requests for tests purposes, default false.
        @stub_responses = false
        send_push_notifications
        @notification.update_attributes(date_sent: DateTime.current)
      elsif type == 'update_badge'
        @user = Stylist.find_by(id: user_id) || Admin.find_by(id: user_id)
        return if @user.blank?

        update_badge
      end
    end

    private

    def update_badge
      @user.devices.each do |device|
        next unless device.token.present?

        p "#{@user.email_address} have device token #{device.token}, update badge"

        begin
          badge = @user.user_notifications.where(dismiss_date: nil).count
          sns.publish(
            target_arn: endpoint_arn(device.token, device.platform),
            message: badge_message(badge, device.platform).to_json,
            message_structure: 'json')
        rescue => error
          p "#{@user.email_address} sns publish error #{error.inspect}"
          NewRelic::Agent.notice_error(error)
          Rollbar.error(error)
        end
      end
    end

    def users_scope(cls)
      if !Rails.env.production? || @notification.stylists.exists?
        cls.where(id: @notification.stylists.pluck(:id))
      else
        scope = cls.where.not(encrypted_password: '')
        if cls != Admin
          scope = scope.includes(:location).where(locations: { country: @notification.country_code })
        end
        cls.where(id: scope.pluck(:id))
      end
    end

    # move it to separate class
    def create_in_app_notifications(cls)
      cls.connection.execute <<-SQL
        INSERT INTO user_notifications
        (userable_id, userable_type, notification_id, created_at, updated_at)
        SELECT
          unnest((#{users_scope(cls).select('array_agg(id)').to_sql})),
          '#{cls.name}',
          #{@notification.id},
          current_timestamp,
          current_timestamp;
      SQL
    end

    def sns
      @sns ||= Aws::SNS::Client.new(stub_responses: @stub_responses,
                                    region: ENV['SNS_REGION'],
                                    credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'],
                                                                      ENV['AWS_SECRET_ACCESS_KEY']))
    end

    def send_push_notifications
      @notification.user_notifications.reload.each do |user_notification|
        user = user_notification.userable
        next if user.blank?

        user.devices.each do |device|
          next unless device.token.present?

          p "#{user.email_address} DOES have device token #{device.token}, publish notification"
          begin
            badge = user.user_notifications.where(dismiss_date: nil).count
            sns.publish(
              target_arn: endpoint_arn(device.token, device.platform),
              message: sns_message(user_notification.id, badge, device.platform).to_json,
              message_structure: 'json')
          rescue => error
            p "#{user.email_address} sns publish error #{error.inspect}"
            NewRelic::Agent.notice_error(error)
            Rollbar.error(error)
          end
        end
      end
    end

    # platform_application_arn - ARN string to identify application from AWS SNS applications list.
    # it’s used to create endpoint e.g: arn:aws:sns:us-west-2:6044379833333:app/APNS/production-application for Apple iOS Prod.
    # device_token - Unique identifier created by the notification service for an app on a device. The specific name for Token will vary, depending on which notification service is being used. For example, when using APNS as the notification service, you need the device token. Alternatively, when using GCM or ADM, the device token equivalent is called the registration ID.
    # Determine device -> message recipient
    def endpoint_arn(device_token, platform='ios')
      arn = platform == 'ios' ? ENV['SNS_IOS_ARN'] : ENV['SNS_ANDROID_ARN']
      sns
        .create_platform_endpoint(platform_application_arn: arn, token: device_token)
        .endpoint_arn
    end

    def badge_message(badge, platform='ios')
      if platform == 'ios'
        { APNS: { aps: { badge: badge } }.to_json }
      else
        { GCM: { notification: { badge: badge } }.to_json }
      end
    end

    # Define a push notification message with metadata
    # text - text message that will be sent to mobile device.
    # push_content - some extra data in hash format that will be sent with text message to mobile device.
    def sns_message(id, badge, platform = 'ios')
      push_content = { object_type: @notification.content_object&.class&.name,
                       object_id: @notification.content_object&.id,
                       user_notification_id: id
      }
      if platform == 'ios'
        payload = {
          notification_id: @notification.id,
          aps: {
            alert: {title: @notification.title,
                    body: @notification.notification_text},
            badge: badge,
            sound: 'default'
          },
          push_content: push_content
        }

        # The same message will be sent to production and sandbox
        sns_message = {
          default: @notification.title,
          APNS: payload.to_json,
          APNS_SANDBOX: payload.to_json
        }
      else
        payload = {
          notification_id: @notification.id,
          notification: {
            body: @notification.notification_text,
            title: @notification.title,
            badge: badge,
            #sound: 'default'
          },
          data: push_content
        }

        sns_message = {
          default: @notification.title,
          GCM: payload.to_json,
        }
      end

      sns_message
    end
  end
end
