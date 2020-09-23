require 'logger'
require 'uri'
require 'faraday'
require 'faraday_middleware'
require 'finix/response/finix_error_middleware'


module Finix
  class Client

    DEFAULT_CONFIG = {
      :logging_level => 'WARN',
      :connection_timeout => 60,
      :read_timeout => 60,
      :logger => nil,
      :ssl_verify => true,
      :faraday_adapter => Faraday.default_adapter,
    }

    attr_reader :conn
    attr_accessor :config

    def initialize(options={})
      @config = DEFAULT_CONFIG.merge options
      build_conn
    end

    def build_conn
      if config[:logger]
        logger = config[:logger]
      else
        logger = Logger.new(STDOUT)
        logger.level = Logger.const_get(config[:logging_level].to_s)
      end

      Faraday::Response.register_middleware :handle_api_errors => lambda { Faraday::Response::RaiseApiError }

      options = {
        :request => {
          :open_timeout => config[:connection_timeout],
          :timeout => config[:read_timeout]
        },
        :ssl => {
          :verify => @config[:ssl_verify] # Only set this to false for testing
        }
      }
      @conn = Faraday.new(@config[:url], options) do |cxn|
        cxn.request :multipart
        cxn.request :url_encoded
        cxn.request :json
        cxn.response :logger, logger
        cxn.response :handle_api_errors
        cxn.response :json
        cxn.adapter  config[:faraday_adapter]
      end
      conn.headers['User-Agent'] = "finix-ruby/#{Finix::VERSION}"
    end

    def method_missing(method, *args, &block)
      href_or_uri = args[0]
      args[0] = "#{@config[:root_url]}/#{href_or_uri}" unless href_or_uri =~ /\A#{URI::regexp(%w(http https))}\z/
      if is_http_method? method
        # TODO use auth property
        conn.basic_auth(@config[:user], @config[:password]) unless @config[:user].nil? and @config[:password].nil?
        conn.send method, *args do |req|
          req.headers['Content-Type'] = 'application/json'
          req.headers['Content-Type']  = 'multipart/form-data' if ((not req.body.nil?) and req.body.key?('file'))
        end
      else
        super method, *args, &block
      end
    end

    private

    def is_http_method? method
      [:get, :post, :put, :delete].include? method
    end

    def respond_to?(method, include_private = false)
      if is_http_method? method
        true
      else
        super method, include_private
      end
    end
  end
end
