module Finix
  class SettlementV2
    include Finix::Resource
    include Finix::HypermediaRegistry

    define_hypermedia_types ['settlement_engine/settlements']
  end
end
