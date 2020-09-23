module Finix
  class Processor
    include Finix::Resource
    include Finix::HypermediaRegistry

    define_hypermedia_types [:processors]
  end
end