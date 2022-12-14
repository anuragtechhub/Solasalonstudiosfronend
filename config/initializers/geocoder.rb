# frozen_string_literal: true

Geocoder.configure(
  # Geocoding options
  # timeout: 7,                 # geocoding service timeout (secs)
  lookup:    :google, # name of geocoding service (symbol)
  ip_lookup: :google,
  # language: :en,              # ISO-639 language code
  # use_https: false,           # use HTTPS for lookup requests? (if supported)
  # http_proxy: nil,            # HTTP proxy server (user:pass@host:port)
  # https_proxy: nil,           # HTTPS proxy server (user:pass@host:port)
  api_key:   'AIzaSyD2Oj3CGe7UCPl_stI1vAIZ1WLVuoJ8WF8' # API key for geocoding service
  # cache: nil,                 # cache object (must respond to #[], #[]=, and #keys)
  # cache_prefix: 'geocoder:',  # prefix (string) to use for all cache keys

  # Exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and TimeoutError
  # always_raise: [],
  # Calculation options
  # units: :mi,                 # :km for kilometers or :mi for miles
  # distances: :linear          # :spherical or :linear
)
