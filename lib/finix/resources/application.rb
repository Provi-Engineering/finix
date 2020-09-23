module Finix
  class Application
    include Finix::Resource
    include Finix::HypermediaRegistry

    define_hypermedia_types [:applications]

    def create_partner_user(attrs={})
      attrs = attrs.attributes if attrs.is_a?(Finix::Resource)
      self.users.create(attrs)
    end

    def create_processor(attrs={})
      attrs = attrs.attributes if attrs.is_a?(Finix::Resource)
      self.processors.create(attrs)
    end
    alias enable_processor create_processor

    def create_token(attrs={})
      attrs = attrs.attributes if attrs.is_a?(Finix::Resource)
      self.tokens.create(attrs)
    end
  end
end
