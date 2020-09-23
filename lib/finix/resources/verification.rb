module Finix
  class Verification
    include Finix::Resource
    include Finix::HypermediaRegistry

    define_hypermedia_types [:verifications]
  end
end
