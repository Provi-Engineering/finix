require_relative 'finix/version' unless defined? Finix::VERSION
require_relative  'finix/client'
require_relative  'finix/errors'

module Finix

  @client = nil
  @config = {:root_url => 'https://localhost/processing'}
  @hypermedia_registry = {}
  @errors_registry = {
      :unknown => Errors,
      400 => BadRequest,
      401 => Unauthorized,
      402 => PaymentRequired,
      403 => Forbidden,
      404 => NotFound,
      405 => MethodNotAllowed,
      422 => UnprocessableEntity,
      500 => InternalServerError
  }

  class << self

    attr_accessor :client
    attr_accessor :config
    attr_accessor :hypermedia_registry
    attr_accessor :errors_registry

    def configure(options={})
      unless options[:root_url].nil?
        @config = {}
      end

      @config = @config.merge(options)
      @config[:user] = @config[:user].strip unless @config[:user].nil?
      @config[:password] = @config[:password].strip unless @config[:password].nil?

      @client = Client.new @config
    end

    def split_the_href(href)
      URI.parse(href).path.sub(/\/$/, '').split('/')
    end

    def get_href(cls)
      href = hypermedia_registry.key(cls)
      sps = cls
      while href.nil?
        sps = sps.superclass
        break if sps.nil?
        clss = Finix::Utils.eval_class cls, sps
        href = hypermedia_registry.key(clss)
      end
      href
    end

    def from_hypermedia_registry(href, attributes={})
      split_uri = split_the_href(href)
      split_uri.reverse!.each do |resource|
        cls = find_resource_cls(resource, attributes)
        return cls unless cls.nil?
      end
      Finix::Utils.eval_class self, UnknownResource
    end

    def find_resource_cls(resource, attributes={})
      cls = hypermedia_registry[resource]
      cls = cls.send :hypermedia_subtype, attributes if not cls.nil? and cls.respond_to?(:hypermedia_subtype)
      cls
    end

    def get(*args, &block)
      self.client.get *args
    end

    def post(*args, &block)
      self.client.post *args
    end

    def put(*args, &block)
      self.client.put *args
    end
  end
end

require 'finix/resources'