require "net/http"
require "json"

module CustomersMailCloud
  class Client
    def initialize api_user, api_key
      @api_user = api_user
      @api_key = api_key
      @endpoints = {
        trial: "https://sandbox.smtps.jp/api/v2/emails/send.json",
        standard: "https://te.smtps.jp/api/v2/emails/send.json",
        pro: "https://SUBDOMAIN.smtps.jp/api/v2/emails/send.json"
      }
      @url = ""
      @to = []
      @from = nil
      @subject = ''
      @text = ''
      @html = ''
      @attachments = []
    end
    attr_accessor :api_user, :api_key, :to, :from,
                  :subject, :text, :html, :attachments
    def trial
      @url = @endpoints[:trial]
    end

    def standard
      @url = @endpoints[:standard]
    end

    def pro(subdomain)
      raise Error.new 'サブドメインは必須です' if subdomain == nil || subdomain == ''
      @url = @endpoints[:pro].gsub('SUBDOMAIN', subdomain)
    end

    def send
      raise Error.new '契約プランを選択してください（trial/standard/pro）' if @url == nil || @url == ''
      raise Error.new '送信元アドレスは必須です' if @from == nil
      raise Error.new '送り先が指定されていません' if @to.size == 0
      raise Error.new '件名は必須です' if @subject == ''
      raise Error.new 'メール本文は必須です' if @text == ''

      params = { 
        api_user: @api_user,
        api_key: @api_key,
        to: @to.map(&:to_h),
        from: @from.to_h,
        subject: @subject,
        text: @text
      }
      params.html = @html if self.html != ''
      headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
      uri = URI.parse(@url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      response = http.post(uri.path, params.to_json, headers)
      if response.code == "200"
        return JSON.parse response.body
      else
        message = JSON.parse(response.body)['errors'].map do |error|
          "#{error['message']} (#{error['code']})"
        end.join(" ")
        raise Error.new message
      end
    end
  end
end
