module Finix
  module Verifiable
    def verify(attrs={})
      attrs = attrs.attributes if attrs.is_a?(Finix::Resource)
      return self.verifications.create(attrs) unless self.verifications.nil?
      raise NotImplementedError.new 'not found `verifications` rel'
    end
  end
end
