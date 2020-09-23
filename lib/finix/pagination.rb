require 'cgi'
require 'ostruct'
require_relative 'hal_resource'
require_relative 'indifferent_hash'

module Finix
  class Pagination

    include ::Enumerable
    include HalResource

    attr_accessor :resource_class
    attr_reader :attributes
    attr_reader :hyperlinks

    def initialize(*args)
      opts = args.slice!(0) || {}
      href = opts.delete(:href)

      @hyperlinks = Finix::Utils.eval_class(self, IndifferentHash).new
      @hyperlinks[:self] = href
      @attributes = {}
      @resource_class = nil
      extract_opts opts
    end

    def init!(*args)
      opts = args.slice(0) || {}
      extract_opts opts
      self
    end

    def each
      return enum_for :each unless block_given?
      fetch_first
      loop do
        items.each { |item| yield item }
        fetch :next
      end
    end

    def count(*args)
      refresh # always refresh to get last items
      return super *args if block_given?
      self.send :method_missing, :count, args
    end

    def fetch(scope = nil) # :next, :last, :first, :prev, :self
      opts = {}
      if scope.is_a? Hash
        opts = Finix::Utils.indifferent_read_access scope
        scope = nil
      end

      scope = :self if scope.nil?
      scope = scope.to_s.to_sym unless scope.nil?
      if @hyperlinks[scope]
        load_from @hyperlinks[scope], opts
        return self.items
      end

      raise StopIteration
    end

    alias retrieve fetch

    def refresh
      fetch
      self
    end

    def create(attrs={})
      attrs = attrs.attributes if attrs.is_a?(Resource)
      attrs = Finix::Utils.indifferent_read_access attrs

      href = @hyperlinks[:self]
      @resource_class = Finix.from_hypermedia_registry href, attrs

      attrs[:href] = href
      @resource_class.new(attrs).save
    end

    private

    def fetch_first
      @attributes['page']['offset'] = 0 unless @attributes['page']['offset'].nil?
      fetch(@hyperlinks[:first] ? :first : nil)
    end

    def extract_opts(opts={})
      opts = Finix::Utils.indifferent_read_access opts
      limit = opts.delete('limit')
      offset = opts.delete('offset')
      @attributes['page'] = @attributes['page'] || {}
      @attributes['page']['limit'] = limit unless limit.nil?
      @attributes['page']['offset'] = offset unless offset.nil?
      @attributes.merge! opts unless opts.empty?

      if not limit.nil? or not offset.nil? # reset @hyperlinks
        @hyperlinks.reject! {|k, v| k.to_s != 'self'}
        parsed_url = URI.parse(@hyperlinks[:self])
        parsed_url.query = nil
        @hyperlinks[:self] = parsed_url.to_s
      end
    end

    def load_from(url, opts = {})
      parsed_url = URI.parse(url)

      params = {}
      params.merge! @attributes['page'] if @attributes.has_key? 'page'
      params.merge! parse_query(parsed_url.query)
      parsed_url.query = nil # remove query

      # params page
      opts ||= {}
      page = opts.delete('page')
      unless page.nil?
        page = Finix::Utils.indifferent_read_access page
        params.merge! page unless page.nil?
      end

      params.merge! opts unless opts.empty?
      params.delete('count') # remove count from previous query

      response = Finix.get parsed_url.to_s, params
      load_page_from_response! response
      # body = Finix::Utils.indifferent_read_access response.body
      #
      # @hyperlinks = Finix::Utils.eval_class(self, IndifferentHash).new
      # links = body.delete('_links')
      # links.each { |key, link| @hyperlinks[key.to_sym] = link[:href] }
      #
      # @attributes = {'items' => [], 'page' => body.delete('page')} # clear attributes
      # if body.has_key? '_embedded'
      #   resource_name, resources = body.delete('_embedded').first
      #   @resource_class = Finix.from_hypermedia_registry resource_name
      #   @attributes['items'] = resources.map do |attrs|
      #     cls = Finix.from_hypermedia_registry resource_name, attrs
      #     cls.construct_from_response attrs
      #   end
      # end
    end

    # Stolen from Mongrel, with some small modifications:
    # Parses a query string by breaking it up at the '&'
    # and ';' characters.  You can also use this to parse
    # cookies by changing the characters used in the second
    # parameter (which defaults to '&;').
    def parse_query(qs, d = nil)
      params = {}
      (qs || '').split(d ? /[#{d}] */n : /[&;] */n).each do |p|
        k, v = p.split('=', 2).map { |x| CGI::unescape(x) }
        if (cur = params[k])
          if cur.class == Array
            params[k] << v
          else
            params[k] = [cur, v]
          end
        else
          params[k] = v
        end
      end

      params
    end
  end
end

