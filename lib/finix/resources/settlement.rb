module Finix
  class Settlement
    include Finix::Resource
    include Finix::HypermediaRegistry

    define_hypermedia_types [:settlements]
  end
end