module Finix
  class PaymentCard < PaymentInstrument

    def initialize(attributes = {}, self_href = nil)
      super(attributes, self_href)
      self.type = 'PAYMENT_CARD'
    end
  end
end
