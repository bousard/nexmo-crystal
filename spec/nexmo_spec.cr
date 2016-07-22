require "spec"
require "webmock"
require "../src/nexmo"

Spec.before_each { WebMock.reset }

describe "Nexmo::Client" do
  api_key = "api_key_xxx"

  api_secret = "api_secret_xxx"

  api_host = "api.nexmo.com"

  host = "rest.nexmo.com"

  client = Nexmo::Client.new(api_key: api_key, api_secret: api_secret)

  response = {body: %[{"key":"value"}], headers: {"Content-Type" => "application/json;charset=utf-8"}}

  response_object = {"key" => "value"}

  describe "send_sms method" do
    it "posts to the sms resource and returns the response object" do
      WebMock.stub(:post, "https://#{host}/sms/json").
        with(body: "api_key=#{api_key}&api_secret=#{api_secret}&from=Crystal&to=1234567890&text=Hello%21").
        to_return(**response)

      client.send_sms(from: "Crystal", to: "1234567890", text: "Hello!").should eq(response_object)
    end
  end

  describe "get_balance method" do
    it "fetches the account balance resource and returns the response object" do
      WebMock.stub(:get, "https://#{host}/account/get-balance?api_key=#{api_key}&api_secret=#{api_secret}").
        to_return(**response)

      client.get_balance.should eq(response_object)
    end
  end

  describe "get_country_pricing method" do
    it "fetches the outbound pricing resource for the given country and returns the response object" do
      WebMock.stub(:get, "https://#{host}/account/get-pricing/outbound?api_key=#{api_key}&api_secret=#{api_secret}&country=CA").
        to_return(**response)

      client.get_country_pricing("CA").should eq(response_object)
    end
  end

  describe "get_prefix_pricing method" do
    it "fetches the outbound pricing resource for the given prefix and returns the response object" do
      WebMock.stub(:get, "https://#{host}/account/get-prefix-pricing/outbound?api_key=#{api_key}&api_secret=#{api_secret}&prefix=44").
        to_return(**response)

      client.get_prefix_pricing("44").should eq(response_object)
    end
  end

  describe "get_sms_pricing method" do
    it "fetches the outbound sms pricing resource for the given phone number and returns the response object" do
      WebMock.stub(:get, "https://#{host}/account/get-phone-pricing/outbound/sms?api_key=#{api_key}&api_secret=#{api_secret}&phone=447525856424").
        to_return(**response)

      client.get_sms_pricing("447525856424").should eq(response_object)
    end
  end

  describe "get_voice_pricing method" do
    it "fetches the outbound voice pricing resource for the given phone number and returns the response object" do
      WebMock.stub(:get, "https://#{host}/account/get-phone-pricing/outbound/voice?api_key=#{api_key}&api_secret=#{api_secret}&phone=447525856424").
        to_return(**response)

      client.get_voice_pricing("447525856424").should eq(response_object)
    end
  end

  describe "update_settings method" do
    it "updates the account settings resource with the given parameters and returns the response object" do
      WebMock.stub(:post, "https://#{host}/account/settings").
        with(body: "api_key=#{api_key}&api_secret=#{api_secret}&moCallBackUrl=http%3A%2F%2Fexample.com%2Fcallback").
        to_return(**response)

      client.update_settings(moCallBackUrl: "http://example.com/callback").should eq(response_object)
    end
  end

  describe "topup method" do
    it "updates the account top-up resource with the given parameters and returns the response object" do
      WebMock.stub(:post, "https://#{host}/account/top-up").
        with(body: "api_key=#{api_key}&api_secret=#{api_secret}&trx=00X123456Y7890123Z").
        to_return(**response)

      client.topup(trx: "00X123456Y7890123Z").should eq(response_object)
    end
  end

  describe "get_account_numbers method" do
    it "fetches the account numbers resource with the given parameters and returns the response object" do
      WebMock.stub(:get, "https://#{host}/account/numbers?api_key=#{api_key}&api_secret=#{api_secret}&size=25&pattern=33").
        to_return(**response)

      client.get_account_numbers(size: 25, pattern: "33").should eq(response_object)
    end
  end

  describe "get_available_numbers method" do
    it "fetches the number search resource with the given parameters and returns the response object" do
      WebMock.stub(:get, "https://#{host}/number/search?api_key=#{api_key}&api_secret=#{api_secret}&country=CA&size=25").
        to_return(**response)

      client.get_available_numbers("CA", size: 25).should eq(response_object)
    end
  end

  describe "buy_number method" do
    it "purchases the number requested with the given parameters and returns the response object" do
      WebMock.stub(:post, "https://#{host}/number/buy").
        with(body: "api_key=#{api_key}&api_secret=#{api_secret}&country=US&msisdn=number").
        to_return(**response)

      client.buy_number(country: "US", msisdn: "number").should eq(response_object)
    end
  end

  describe "cancel_number method" do
    it "cancels the number requested with the given parameters and returns the response object" do
      WebMock.stub(:post, "https://#{host}/number/cancel").
        with(body: "api_key=#{api_key}&api_secret=#{api_secret}&country=US&msisdn=number").
        to_return(**response)

      client.cancel_number(country: "US", msisdn: "number").should eq(response_object)
    end
  end

  describe "update_number method" do
    it "updates the number requested with the given parameters and returns the response object" do
      WebMock.stub(:post, "https://#{host}/number/update").
        with(body: "api_key=#{api_key}&api_secret=#{api_secret}&country=US&msisdn=number&moHttpUrl=callback").
        to_return(**response)

      client.update_number(country: "US", msisdn: "number", moHttpUrl: "callback").should eq(response_object)
    end
  end

  describe "initiate_call method" do
    it "posts to the call resource and returns the response object" do
      WebMock.stub(:post, "https://#{host}/call/json").
        with(body: "api_key=#{api_key}&api_secret=#{api_secret}&to=16365553226&answer_url=http%3A%2F%2Fexample.com%2Fanswer").
        to_return(**response)

      client.initiate_call(to: "16365553226", answer_url: "http://example.com/answer")
    end
  end

  describe "initiate_tts_call method" do
    it "posts to the tts resource and returns the response object" do
      WebMock.stub(:post, "https://#{api_host}/tts/json").
        with(body: "api_key=#{api_key}&api_secret=#{api_secret}&to=16365553226&text=Hello").
        to_return(**response)

      client.initiate_tts_call(to: "16365553226", text: "Hello")
    end
  end

  describe "initiate_tts_prompt_call method" do
    it "posts to the tts prompt resource and returns the response object" do
      WebMock.stub(:post, "https://#{api_host}/tts-prompt/json").
        with(body: "api_key=#{api_key}&api_secret=#{api_secret}&to=16365553226&text=Hello&max_digits=4&bye_text=Goodbye").
        to_return(**response)

      client.initiate_tts_prompt_call(to: "16365553226", text: "Hello", max_digits: 4, bye_text: "Goodbye")
    end
  end

  describe "start_verification method" do
    it "posts to the verify json resource and returns the response object" do
      WebMock.stub(:post, "https://#{api_host}/verify/json").
        with(body: "api_key=#{api_key}&api_secret=#{api_secret}&number=447525856424&brand=MyApp").
        to_return(**response)

      client.start_verification(number: "447525856424", brand: "MyApp")
    end
  end

  describe "check_verification method" do
    it "posts to the verify check resource and returns the response object" do
      WebMock.stub(:post, "https://#{api_host}/verify/check/json").
        with(body: "api_key=#{api_key}&api_secret=#{api_secret}&code=123445&request_id=8g88g88eg8g8gg9g90").
        to_return(**response)

      client.check_verification("8g88g88eg8g8gg9g90", code: "123445")
    end
  end

  describe "get_verification method" do
    it "fetches the verify search resource with the given request id and returns the response object" do
      WebMock.stub(:get, "https://#{api_host}/verify/search/json?api_key=#{api_key}&api_secret=#{api_secret}&request_id=8g88g88eg8g8gg9g90").
        to_return(**response)

      client.get_verification("8g88g88eg8g8gg9g90")
    end
  end

  describe "cancel_verification method" do
    it "posts to the verify control resource and returns the response object" do
      WebMock.stub(:post, "https://#{api_host}/verify/control/json").
        with(body: "api_key=#{api_key}&api_secret=#{api_secret}&request_id=8g88g88eg8g8gg9g90&cmd=cancel").
        to_return(**response)

      client.cancel_verification("8g88g88eg8g8gg9g90")
    end
  end

  describe "trigger_next_verification_event method" do
    it "posts to the verify control resource and returns the response object" do
      WebMock.stub(:post, "https://#{api_host}/verify/control/json").
        with(body: "api_key=#{api_key}&api_secret=#{api_secret}&request_id=8g88g88eg8g8gg9g90&cmd=trigger_next_event").
        to_return(**response)

      client.trigger_next_verification_event("8g88g88eg8g8gg9g90")
    end
  end

  describe "get_basic_number_insight method" do
    it "fetches the number format resource and returns the response object" do
      WebMock.stub(:get, "https://#{api_host}/number/format/json?api_key=#{api_key}&api_secret=#{api_secret}&number=447525856424").
        to_return(**response)

      client.get_basic_number_insight(number: "447525856424")
    end
  end

  describe "get_number_insight method" do
    it "fetches the number lookup resource and returns the response object" do
      WebMock.stub(:get, "https://#{api_host}/number/lookup/json?api_key=#{api_key}&api_secret=#{api_secret}&number=447525856424").
        to_return(**response)

      client.get_number_insight(number: "447525856424")
    end
  end

  it "includes a user-agent header with the library version number and crystal version number" do
    WebMock.stub(:get, "https://#{host}/account/get-balance?api_key=#{api_key}&api_secret=#{api_secret}").
      with(headers: {"User-Agent" => "nexmo-crystal/#{Nexmo::VERSION}/#{Crystal::VERSION}"}).
      to_return(**response)

    client.get_balance
  end

  it "raises an authentication error exception if the response code is 401" do
    WebMock.stub(:get, "https://#{host}/account/get-balance?api_key=#{api_key}&api_secret=#{api_secret}").
      to_return(status: 401)

    expect_raises(Nexmo::AuthenticationError) { client.get_balance }
  end

  it "raises a client error exception if the response code is 4xx" do
    WebMock.stub(:get, "https://#{host}/account/get-balance?api_key=#{api_key}&api_secret=#{api_secret}").
      to_return(status: 400)

    expect_raises(Nexmo::ClientError) { client.get_balance }
  end

  it "raises a server error exception if the response code is 5xx" do
    WebMock.stub(:get, "https://#{host}/account/get-balance?api_key=#{api_key}&api_secret=#{api_secret}").
      to_return(status: 500)

    expect_raises(Nexmo::ServerError) { client.get_balance }
  end
end
