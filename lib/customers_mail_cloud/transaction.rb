module CustomersMailCloud
  class Transaction
    def initialize type, client
      @client = client
      @type = type
      @server_composition = nil
      @base_url = 'https://api.smtps.jp/transaction/v2/__TYPE__/__ACTION__.json'
      @params = {}
    end

    attr_accessor :server_composition

    def url action
      @base_url.gsub('__TYPE__', @type).gsub('__ACTION__', action)
    end

    def list
      params = @params
      params[:api_user] = @client.api_user
      params[:api_key] = @client.api_key
      unless @server_composition
        raise Error.new('Server Composition is required.')
      end
      params[:server_composition] = @server_composition
      headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
      uri = URI.parse url('list')
      req = Net::HTTP::Post.new(uri.path)
      req.body = params.to_json
      headers.each do |k, v|
        req[k] = v
      end
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = true
      response = http.request req
      if response.code == '200' || response.code == '204'
        return [] if response.body.nil?
        return JSON.parse(response.body)[@type]
      else
        message = JSON.parse(response.body)['errors'].map do |error|
          "#{error['message']} (#{error['code']})"
        end.join(" ")
        raise Error.new message
      end
    end

    def email= address
      @params[:email] = address
    end
  
    def status= status
      @params[:status] = status
    end
  
    def start_date= date
      @params[:start_date] = date.strftime('%Y-%m-%d')
    end
  
    def end_date= date
      @params[:end_date] = date.strftime('%Y-%m-%d')
    end
    
    def date= date
      @params[:date] = date.strftime('%Y-%m-%d')
    end
  
    def hour= hour
      if hour < 0 || hour > 23
        raise Error.new('hour allows the range from 0 to 23.')
      end
      @params[:hour] = hour
    end
  
    def minute= minute
      if minute < 0 || minute > 59
        raise Error.new('minute allows the range from 0 to 59.')
      end
      @params[:minute] = minute
    end
    
    def page= page
      @params[:p] = page
    end
  
    def limit= limit
      @params[:r] = limit
    end  
  end
end