module Finix
  module HalResource

    attr_accessor :hyperlinks
    attr_accessor :attributes

    def method_missing(method, *args, &block)
      [@attributes, @attributes['page'] || {}].each do |attrs|
        if attrs.has_key?(method.to_s)
          return attrs[method.to_s]
        end
      end

      if @attributes.empty? or (@attributes.has_key?('page') and not @attributes.has_key?('items'))
        self.refresh if self.respond_to? :refresh
        return self.send :method_missing, method, *args, &block
      end

      case method.to_s
        when /(.+)=$/ # support setting
          attr = method.to_s.chop
          @attributes[attr] = args.slice(0)
        else
          @hyperlinks.send :method_missing, method, *args, &block
      end
    end

    def load_page_from_response!(response)
      body = Finix::Utils.indifferent_read_access response.body

      @hyperlinks = Finix::Utils.eval_class(self, IndifferentHash).new
      links = body.delete('_links')
      links.each { |key, link| @hyperlinks[key.to_sym] = link[:href] } unless links.nil?

      @attributes = {'items' => [], 'page' => body.delete('page')} # clear attributes
      if body.has_key? '_embedded'
        resource_name, resources = body.delete('_embedded').first
        @resource_class = Finix.from_hypermedia_registry resource_name
        @attributes['items'] = resources.map do |attrs|
          cls = Finix.from_hypermedia_registry resource_name, attrs
          cls.construct_from_response attrs
        end
      end
    end
  end
end
