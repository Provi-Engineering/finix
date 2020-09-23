module Finix
  class Refund
    include Finix::Resource
    include Finix::HypermediaRegistry

    define_hypermedia_types [:reversals]
  end
end
