require 'net/http'
require 'json'

class Apicalypse
  class Request
    def initialize(uri, options)
      @uri = uri
      @options = options
    end

    def perform(scope)
      uri = build_uri(scope)
      body = build_body(scope)

      response = http_get(uri, body)
      raise_on_http_error(response)

      JSON.parse(response.body)
    end

    private

    def build_uri(scope)
      uri = URI(@uri)

      return uri unless query_method_url?

      uri.query = if scope.chain[:query]
                    scope.chain[:query]
                  else
                    scope.chain.to_query
                  end

      uri
    end

    def build_body(scope)
      return scope.chain[:query] if scope.chain[:query]

      scope.chain.map do |k, v|
        if v.is_a?(Hash)
          "#{k} #{v.keys[0]}=#{v.values[0]};"
        else
          "#{k} #{v};"
        end
      end.join('')
    end

    def http_get(uri, body)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        req = Net::HTTP::Get.new(uri, request_headers)
        req.body = body unless query_method_url?

        http.request req
      end
    end

    def request_headers
      headers = { 'Accept' => 'application/json' }
      headers.merge!(@options[:headers]) if @options[:headers]

      headers
    end

    def raise_on_http_error(response)
      return if response.is_a? Net::HTTPSuccess

      raise "Request failed with status #{response.code}: #{response.body}"
    end

    def query_method_url?
      @options[:query_method] == :url
    end
  end
end
