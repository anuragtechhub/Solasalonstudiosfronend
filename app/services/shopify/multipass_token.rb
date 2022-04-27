# frozen_string_literal: true

require 'openssl'
require 'base64'
require 'time'
require 'json'

class Shopify::MultipassToken
  SHOPIFY_HOST = "https://#{ENV.fetch('SHOPIFY_LOGIN', nil)}:#{ENV.fetch('SHOPIFY_PASSWORD', nil)}@solasalon.myshopify.com"

  def initialize(user)
    ### Use the Multipass secret to derive two cryptographic keys,
    ### one for encryption, one for signing
    key_material = OpenSSL::Digest.new('sha256').digest(ENV.fetch('MULTIPASS_SECRET', nil))
    @encryption_key = key_material[0, 16]
    @signature_key  = key_material[16, 16]
    @user           = user
  end

  def generate_token
    ### Serialize the customer data to JSON and encrypt it
    ciphertext = encrypt(customer_data_hash.to_json)

    ### Create a signature (message authentication code) of the ciphertext
    ### and encode everything using URL-safe Base64 (RFC 4648)
    Base64.urlsafe_encode64(ciphertext + sign(ciphertext))
  end

  private

    def customer_data_hash
      ### Store the current time in ISO8601 format.
      ### The token will only be valid for a small timeframe around this timestamp.
      {
        email:      @user.email_address,
        first_name: @user.first_name,
        last_name:  @user.last_name,
        created_at: Time.current.iso8601,
        return_to:  'https://www.beautyhive.com/',
        tag_string: all_tags.join(', ')
      }.compact
    end

    def all_tags
      (current_tags.presence || ['solapro-created']) | %w[approved solastylist solapro-user]
    end

    def current_tags
      url = "#{SHOPIFY_HOST}/admin/api/2021-01/customers.json?email=#{@user.email_address}"
      response = HTTParty.get(url).parsed_response
      return [] if response.blank?
      return [] if response['customers'].blank? || response['customers'].first.blank?

      response['customers'].first['tags'].to_s.split(', ')
    end

    # remote_ip: "107.20.160.121"

    def encrypt(plaintext)
      cipher = OpenSSL::Cipher.new('aes-128-cbc')
      cipher.encrypt
      cipher.key = @encryption_key

      ### Use a random IV
      cipher.iv = iv = cipher.random_iv

      ### Use IV as first block of ciphertext
      iv + cipher.update(plaintext) + cipher.final
    end

    def sign(data)
      OpenSSL::HMAC.digest('sha256', @signature_key, data)
    end
end
