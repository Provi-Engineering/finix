module Finix
  class Token
    include Finix::Resource
    include Finix::HypermediaRegistry

    define_hypermedia_types [:tokens]
  end
end