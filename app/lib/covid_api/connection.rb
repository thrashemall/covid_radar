# frozen_string_literal: true

module CovidApi
  class Connection
    def transport
      @transport ||= Faraday.new('https://api.covid19api.com') do |conn|
        conn.use Faraday::Request::UrlEncoded
        conn.response :json
        conn.response :raise_error
        conn.adapter Faraday.default_adapter
      end
    end

    def post(*params, &block)
      transport.post(*params, &block)
    end

    def get(*params, &block)
      transport.get(*params, &block)
    end
  end
end
