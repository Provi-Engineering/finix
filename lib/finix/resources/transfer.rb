module Finix
  class Transfer
    include Finix::Resource
    include Finix::HypermediaRegistry

    define_hypermedia_types [:transfers]

    def reverse(refund_amount=0)
      self.reversals.create :refund_amount => refund_amount
    end
  end
end
