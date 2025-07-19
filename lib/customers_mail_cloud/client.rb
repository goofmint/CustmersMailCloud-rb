require "net/http"
require "json"
require "net/http/post/multipart"
require 'mime/types'

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
      @env_from = nil
      @reply_to = nil
      @headers = {}
      @charset = 'UTF-8'
      @attachments = []
    end
    attr_accessor :api_user, :api_key, :to, :from,
                  :subject, :text, :html, :envfrom, :replyto, :headers, :charset, :attachments
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

    def bounce
      Transaction.new 'bounces', self
    end

    def delivery
      Transaction.new 'deliveries', self
    end

    def block
      Transaction.new 'blocks', self
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
      params[:envfrom] = @env_from if @env_from
      params[:replyto] = @reply_to.to_h if @reply_to
      if (@headers.empty?)
        params[:headers] = @headers.map do |key, value|
          { name: key, value: value }
        end
      end
      params[:charset] = @charset
      params[:html] = @html if @html != ''
      headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
      uri = URI.parse(@url)
      if @attachments.size > 0
        params[:attachments] = @attachments.size
        [:to, :from].each do |k|
          params[k] = params[k].to_json
        end
        @attachments.each_with_index do |a, i|
          if a.is_a? String
            a = File.new(a)
          end
          mimeType = MIME::Types.type_for(a.path)[0]
          params["attachment#{i + 1}"] = UploadIO.new a, mimeType ? mimeType.to_s : 'application/octet-stream', File.basename(a)
        end
        req = Net::HTTP::Post::Multipart.new(uri.path, params)
      else
        req = Net::HTTP::Post.new(uri.path)
        req.body = params.to_json
        headers.each do |k, v|
          req[k] = v
        end
      end
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = true
      response = http.request req
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
