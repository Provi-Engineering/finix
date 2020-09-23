require 'addressable/template'

require_relative '../utils'
require_relative '../hal_resource'
require_relative '../pagination'
require_relative '../indifferent_hash'

module Finix

  module Resource

    include HalResource

    def initialize(*args)
      opts = args.slice!(0) || {}
      href = opts.delete(:href)
      @attributes = Finix::Utils.indifferent_read_access opts

      @hyperlinks = Finix::Utils.eval_class(self, IndifferentHash).new
      @hyperlinks[:self] = href if href =~ URI::regexp
    end

    alias links hyperlinks

    def hydrate(links)
      links.each do |key, link|
        property = key.sub(/.*?\./, '')

        href = link[:href]
        if property == 'self'
          @hyperlinks[:self] = href
        else
          split_uri = Finix.split_the_href(href).reverse!
          cls = Finix.find_resource_cls split_uri[0]
          cls = cls.nil? ? Finix.from_hypermedia_registry(href) : Finix::Utils.eval_class(self, Pagination)
          @hyperlinks[property] = Finix::Utils.callable(cls.new :href => href)
        end
      end
    end

    def fetch(*arguments)
      self.class.find *arguments
    end

    alias find fetch

    def save(options = {}, href = nil)
      options = options.is_a?(Finix::Resource) ? options.attributes : options
      @attributes = @attributes.merge options
      href ||= @hyperlinks[:self]
      method = :post
      if href.nil?
        href = Finix.get_href self.class
      elsif not @attributes[:id].nil?
        method = :put
      end

      attributes_to_submit = self.sanitize
      begin
        @response = Finix.send(method, href, attributes_to_submit)
      rescue Exception
        raise
      end

      refresh @response
    end

    def sanitize
      to_submit = {}
      @attributes.each do |key, value|
        to_submit[key] = value unless value.is_a? Finix::Resource
      end
      to_submit
    end

    def response
      @response
    end

    private :response

    def refresh(the_response = nil)
      if the_response
        return if the_response.body.to_s.length.zero?
        fresh = self.class.construct_from_response the_response.body
      else
        fresh = self.find(@hyperlinks[:self])
      end
      fresh and copy_from fresh
      self
    end

    def copy_from(other)
      other.instance_variables.each do |ivar|
        instance_variable_set ivar, other.instance_variable_get(ivar)
      end
    end

    def to_s
      "#{self.class.name.split('::').last || ''} #{@attributes}"
    end

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      # this is class method, not callable from instance
      def construct_from_response(payload)
        payload = Finix::Utils.indifferent_read_access payload
        links = payload.delete('_links') || {}
        instance = self.new payload
        instance.hydrate(links)
        instance
      end

      def fetch(*arguments)
        if arguments.nil? or arguments.empty? or arguments[0].nil? or arguments[0].to_s.empty?
          href = Finix.hypermedia_registry.key(self)
          return Finix::Utils.eval_class(self, Pagination).new :href => href
        end

        options = arguments.slice!(0) or {}
        if options.is_a? String and options =~ URI::regexp
          href = options
        else
          href = Finix.get_href(self) or Finix.get_href(self.class)
          if options.is_a? Hash
            options = Finix::Utils.indifferent_read_access options
            id = options.delete('id')
          elsif options.is_a? String
            id = options
          end
          href = "#{href}/#{id}" unless id.nil?
        end

        response = Finix.get href
        construct_from_response response.body
      end

      def pagination(*args)
        href = Finix.hypermedia_registry.key(self)
        opts = args.slice!(0) || {}
        opts[:href] = href
        Finix::Utils.eval_class(self, Pagination).new opts
      end

      alias find fetch
      alias retrieve fetch
    end

  end
end
