require "http/client"
require "uri"
require "json"

module Nexmo
  VERSION = "1.0.0"

  class Error < Exception; end

  class ClientError < Error; end

  class ServerError < Error; end

  class AuthenticationError < ClientError; end

  class Client
    @api_key : String

    @api_secret : String

    @api_host : String = "api.nexmo.com"

    @host : String = "rest.nexmo.com"

    def initialize(**options)
      @api_key = options.fetch(:api_key) { ENV["NEXMO_API_KEY"] }

      @api_secret = options.fetch(:api_secret) { ENV["NEXMO_API_SECRET"] }

      @headers = HTTP::Headers {"User-Agent" => "nexmo-crystal/#{Nexmo::VERSION}/#{Crystal::VERSION}"}

      return self
    end

    def send_sms(**params)
      post(@host, "/sms/json", params)
    end

    def get_balance
      get(@host, "/account/get-balance")
    end

    def get_country_pricing(country_code)
      get(@host, "/account/get-pricing/outbound", {country: country_code})
    end

    def get_prefix_pricing(prefix)
      get(@host, "/account/get-prefix-pricing/outbound", {prefix: prefix})
    end

    def get_sms_pricing(number)
      get(@host, "/account/get-phone-pricing/outbound/sms", {phone: number})
    end

    def get_voice_pricing(number)
      get(@host, "/account/get-phone-pricing/outbound/voice", {phone: number})
    end

    def update_settings(**params)
      post(@host, "/account/settings", params)
    end

    def topup(**params)
      post(@host, "/account/top-up", params)
    end

    def get_account_numbers(**params)
      get(@host, "/account/numbers", params)
    end

    def get_available_numbers(country_code, **params)
      get(@host, "/number/search", merge(params, country: country_code))
    end

    def buy_number(**params)
      post(@host, "/number/buy", params)
    end

    def cancel_number(**params)
      post(@host, "/number/cancel", params)
    end

    def update_number(**params)
      post(@host, "/number/update", params)
    end

    def initiate_call(**params)
      post(@host, "/call/json", params)
    end

    def initiate_tts_call(**params)
      post(@api_host, "/tts/json", params)
    end

    def initiate_tts_prompt_call(**params)
      post(@api_host, "/tts-prompt/json", params)
    end

    def start_verification(**params)
      post(@api_host, "/verify/json", params)
    end

    def check_verification(request_id, **params)
      post(@api_host, "/verify/check/json", merge(params, request_id: request_id))
    end

    def get_verification(request_id)
      get(@api_host, "/verify/search/json", {request_id: request_id})
    end

    def cancel_verification(request_id)
      post(@api_host, "/verify/control/json", {request_id: request_id, cmd: "cancel"})
    end

    def trigger_next_verification_event(request_id)
      post(@api_host, "/verify/control/json", {request_id: request_id, cmd: "trigger_next_event"})
    end

    def get_basic_number_insight(**params)
      get(@api_host, "/number/format/json", params)
    end

    def get_number_insight(**params)
      get(@api_host, "/number/lookup/json", params)
    end

    private def get(host, path, params = nil)
      uri = URI.parse("https://" + host + path)

      uri.query = encode(params)

      response = HTTP::Client.get(uri, headers: @headers)

      parse(response, host)
    end

    private def post(host, path, params)
      uri = URI.parse("https://" + host + path)

      response = HTTP::Client.post_form(uri, encode(params), headers: @headers)

      parse(response, host)
    end

    private def parse(response, host)
      case response.status_code
      when 200 .. 299
        if response.content_type == "application/json"
          JSON.parse(response.body)
        else
          response.body
        end
      when 401
        raise AuthenticationError.new("#{response.status_code} response from #{host}")
      when 400 .. 499
        raise ClientError.new("#{response.status_code} response from #{host}")
      when 500 .. 599
        raise ServerError.new("#{response.status_code} response from #{host}")
      else
        raise Error.new("#{response.status_code} response from #{host}")
      end
    end

    private def merge(a : NamedTuple, **b)
      a.to_h.merge(b.to_h)
    end

    private def encode(params : NamedTuple)
      encode(params.to_h)
    end

    private def encode(params : Hash?)
      HTTP::Params.build do |http_params|
        http_params.add "api_key", @api_key
        http_params.add "api_secret", @api_secret

        params.each { |k, v| http_params.add k.to_s, v.to_s } unless params.nil?
      end
    end
  end
end
