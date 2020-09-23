module Finix
  class PaymentInstrument
    include Finix::Resource
    include Finix::HypermediaRegistry
    include Finix::Verifiable

    define_hypermedia_types [:payment_instruments]

    class << self
      def hypermedia_subtype(response)
        unless response.nil?
          type = response['instrument_type'] || response['type']
          if type == 'PAYMENT_CARD'
            name = self.name.sub! 'PaymentInstrument', 'PaymentCard'
          elsif type == 'BANK_ACCOUNT'
            name = self.name.sub! 'PaymentInstrument', 'BankAccount'
          end
          return self.instance_eval name unless name.nil?
        end
        self
      end
    end
  end
end
