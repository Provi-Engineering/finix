module Finix
  class Identity
    include Finix::Resource
    include Finix::HypermediaRegistry
    include Finix::Verifiable

    define_hypermedia_types [:identities]

    def provision_merchant(attrs={})
      self.merchants.create(attrs)
    end

    def create_payment_instrument(attrs={})
      if attrs.is_a?(Finix::Resource)
        attrs.identity = self.id
        attrs = attrs.attributes
      else
        attrs['identity'] = self.id
      end

      self.payment_instruments.create(attrs)
    end

    def create_settlement(attrs={})
      attrs = attrs.attributes if attrs.is_a?(Finix::Resource)
      self.settlements.create(attrs)
    end

  end
end
