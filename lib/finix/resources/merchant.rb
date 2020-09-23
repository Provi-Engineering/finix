module Finix
  class Merchant
    include Finix::Resource
    include Finix::HypermediaRegistry
    include Finix::Verifiable

    define_hypermedia_types [:merchants]
  end
end
