module Rentmanager
  class Client

    class RmUnauthorized < StandardError; end
    class RmTemporaryUnavailable < StandardError; end
    class RmOtherError < StandardError; end
    class RmAccessDenied < StandardError; end

    URL = 'https://solasalon.api.rentmanager.com'.freeze
    ALL_NET_HTTP_ERRORS = [
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError, Net::OpenTimeout,
      Net::HTTPServerException, Net::HTTPFatalError, Net::HTTP::Persistent::Error, Net::HTTPRetriableError,
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

    def properties(location_id)
      request(path: '/Properties?embeds=UserDefinedValues', headers: { 'X-RM12Api-LocationID' => location_id.to_s })
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

    def units(location_id)
      request(path: '/Units', headers: { 'X-RM12Api-LocationID' => location_id.to_s })
    end

    def tenant_leases(location_id, tenant_id)
      request(path: "/Tenants/#{tenant_id}", headers: { 'X-RM12Api-LocationID' => location_id.to_s })
    end

    def tenants(location_id)
      request(path: '/Tenants', headers: { 'X-RM12Api-LocationID' => location_id.to_s })
    end

    def leases(location_id)
      request(path: '/Leases', headers: { 'X-RM12Api-LocationID' => location_id.to_s })
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
        body = JSON.parse(resp.body) rescue resp.body

        if resp.kind_of?(Net::HTTPSuccess)
          return body
        elsif expired_auth_key?(body)
          set_authentication_key
          p "expired auth key. recursive call request with updated key #{@authentication_key}"
          raise RmUnauthorized, resp.message
        elsif service_temporary_unavailable?(body)
          raise RmTemporaryUnavailable, resp.message
        elsif no_access?(body)
          raise RmAccessDenied, resp.message
        else
          raise RmOtherError, resp.message
        end
      rescue *ALL_NET_HTTP_ERRORS => exception
        Rails.logger.error "#{exception.class.name}: #{exception.message}\n#{exception.backtrace.join("\n")}"
        return { error: true, message: exception.message }
      rescue RmUnauthorized, RmTemporaryUnavailable, RmOtherError => exception
        if (retry_times += 1) > RETRY_MAX_TIMES
          p "retry times is exceeded. headers: #{headers}"
          return { error: true, message: exception.message }
        else
          p "service temporary unavailable. retrying. message: exception.message #{exception.message}. headers: #{headers}"
          sleep 20 if exception.message == 'Forbidden'
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
      body = {'Username': ENV['RENTMANAGER_USERNAME'], 'Password': ENV['RENTMANAGER_PASSWORD']}
      request(path: '/Authentication/AuthorizeUser', http_verb: 'post', body: body, need_auth: false).gsub('"','')
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
