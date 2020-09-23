module Finix
  class Evidence
    include Finix::Resource
    include Finix::HypermediaRegistry

    define_hypermedia_types [:evidence]
  end
end
