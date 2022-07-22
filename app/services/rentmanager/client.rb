# frozen_string_literal: true

module Rentmanager
  class Client
    class RmUnauthorized < StandardError; end
    class RmTemporaryUnavailable < StandardError; end
    class RmOtherError < StandardError; end
    class RmAccessDenied < StandardError; end

    URL = 'https://solasalon.api.rentmanager.com'
    ALL_NET_HTTP_ERRORS = [
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError, Net::OpenTimeout,
      Net::HTTPClientException, Net::HTTPFatalError, Net::HTTP::Persistent::Error, Net::HTTPRetriableError,
      Mechanize::ResponseCodeError, Mechanize::Error, Errno::EHOSTUNREACH, Errno::EINVAL, Errno::ECONNRESET,
      EOFError, OpenSSL::SSL::SSLError, Timeout::Error, RmAccessDenied
    ].freeze
    RETRY_MAX_TIMES = 5

    def initialize
      set_authentication_key
    end

    def locations
      request(path: '/Locations')
    end

    def properties(location_id, page = 1)
      request(path: "/Properties?embeds=UserDefinedValues&pagenumber=#{page}", headers: { 'X-RM12Api-LocationID' => location_id.to_s })
    end

    def user_defined_fields(location_id)
      request(path: '/UserDefinedFields', headers: { 'X-RM12Api-LocationID' => location_id.to_s })
    end

    def roles(location_id)
      request(path: '/Roles', headers: { 'X-RM12Api-LocationID' => location_id.to_s })
    end

    def role_privileges(location_id, role_id)
      request(path: "/Roles/#{role_id}/Privileges?embeds=Privilege", headers: { 'X-RM12Api-LocationID' => location_id.to_s })
    end

    def units(location_id, page = 1)
      request(path: "/Units?pagenumber=#{page}", headers: { 'X-RM12Api-LocationID' => location_id.to_s })
    end

    def tenant(location_id, tenant_id)
      request(path: "/Tenants/#{tenant_id}?embeds=Contacts.PhoneNumbers", headers: { 'X-RM12Api-LocationID' => location_id.to_s })
    end

    def tenants(location_id, page = 1)
      request(path: "/Tenants?embeds=Contacts.PhoneNumbers&pagenumber=#{page}", headers: { 'X-RM12Api-LocationID' => location_id.to_s })
    end

    def tenants_save(location_id, body)
      request(path: '/Tenants?embeds=Contacts,Contacts.PhoneNumbers', http_verb: :post, body: body, headers: { 'X-RM12Api-LocationID' => location_id.to_s })
    end

    def leases(location_id, page = 1)
      request(path: "/Leases?pagenumber=#{page}", headers: { 'X-RM12Api-LocationID' => location_id.to_s })
    end

    private

      def request(path:, http_verb: 'get', body: {}, headers: {}, need_auth: true)
        headers = { 'Content-Type' => 'application/json' }.merge(headers)

        begin
          retry_times ||= 0

          if need_auth
            headers['x-rm12api-apitoken'] = @authentication_key
          end

          resp = http_client.start do |http|
            req = "Net::HTTP::#{http_verb.capitalize}".constantize.new(path, headers)
            req.body = body.to_json
            http.request(req)
          end

          # ignore errors while parse
          body = begin
            JSON.parse(resp.body)
          rescue StandardError
            resp.body
          end

          if resp.is_a?(Net::HTTPSuccess)
            body
          elsif expired_auth_key?(body)
            set_authentication_key
            Rails.logger.debug { "expired auth key. recursive call request with updated key #{@authentication_key}" }
            raise RmUnauthorized, resp.message
          elsif service_temporary_unavailable?(body)
            raise RmTemporaryUnavailable, resp.message
          elsif no_access?(body)
            raise RmAccessDenied, resp.message
          else
            raise RmOtherError, begin
              "#{resp.message}. #{body['DeveloperMessage']}"
            rescue StandardError
              resp.message
            end
          end
        rescue *ALL_NET_HTTP_ERRORS => e
          Rails.logger.error "#{e.class.name}: #{e.message}\n#{e.backtrace.join("\n")}"
          { error: true, message: e.message }
        rescue RmUnauthorized, RmTemporaryUnavailable, RmOtherError => e
          if (retry_times += 1) > RETRY_MAX_TIMES
            Rails.logger.debug { "retry times is exceeded. headers: #{headers}" }
            { error: true, message: e.message }
          else
            Rails.logger.debug { "service temporary unavailable. retrying. message: exception.message #{e.message}. headers: #{headers}" }
            sleep 20 if e.message == 'Forbidden'
            retry
          end
        end
      end

      def http_client
        uri = URI(URL)
        @http ||= Net::HTTP.new(uri.host, uri.port).tap do |http|
          http.use_ssl = true
        end
      end

      def get_authentication_key
        body = { Username: ENV.fetch('RENTMANAGER_USERNAME', nil), Password: ENV.fetch('RENTMANAGER_PASSWORD', nil) }
        request(path: '/Authentication/AuthorizeUser', http_verb: 'post', body: body, need_auth: false).gsub('"', '')
      end

      def expired_auth_key?(body)
        body['DeveloperMessage'] == 'Unable to authenticate - Invalid API Token.' &&
          body['Exception'] == 'AuthenticationException'
      end

      def set_authentication_key
        @authentication_key = get_authentication_key
      end

      def service_temporary_unavailable?(body)
        body['DeveloperMessage'] == 'Service unavailable while performing database updates.Try again after a few minutes'
      end

      def no_access?(body)
        body['DeveloperMessage'] == 'Unable to process request - User does not have access to location that token is associated with'
      end
  end
end
