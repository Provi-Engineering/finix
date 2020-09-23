module Finix
  class BankAccount < PaymentInstrument

    def initialize(attributes = {}, self_href = nil)
      super(attributes, self_href)
      self.type = 'BANK_ACCOUNT'
    end
  end
end
