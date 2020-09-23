module Finix
  class Authorization
    include Finix::Resource
    include Finix::HypermediaRegistry

    define_hypermedia_types [:authorizations]

    def void
      self.void_me = true
      self.save
    end

    def capture(attrs={})
      if attrs['capture_amount'].nil?
        attrs['capture_amount'] = self.amount
      end
      self.attributes = self.attributes.merge attrs
      self.save
    end
  end
end
