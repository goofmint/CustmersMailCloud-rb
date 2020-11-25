require "json"
require "date"

RSpec.describe CustomersMailCloud do
  before "setup" do
    config = JSON.parse(open("./config.json").read)
    api_user = config['api_user']
    api_key = config['api_key']
    @client = CustomersMailCloud::Client.new(api_user, api_key)
    @client.from = CustomersMailCloud::MailAddress.new(config['from']['address'], config['from']['name'])
    @client.trial
  end

  it "has a version number" do
    expect(CustomersMailCloud::VERSION).not_to be nil
  end

  it "Send Email test" do
    @client.to << CustomersMailCloud::MailAddress.new('atsushi@moongift.jp', 'Atsushi Nakatsugawa')
    @client.subject = 'Mail subject'
    @client.text = 'Mail body'
    json = @client.send
    expect(json['id']).not_to be nil
  end

  it "Send Email test with error" do
    @client.to << CustomersMailCloud::MailAddress.new('atsushi@moongift.jp', 'Atsushi Nakatsugawa')
    @client.subject = 'Mail subject'
    begin
      json = @client.send
    rescue => e
      expect(e.message).to eq "メール本文は必須です"
    end
  end

  it "Get bounce test" do
    bounce = @client.bounce
    bounce.server_composition = 'sandbox'
    bounce.start_date = Date.parse("2020-11-20")
    bounce.limit = 100
    bounce.list
  end
end
