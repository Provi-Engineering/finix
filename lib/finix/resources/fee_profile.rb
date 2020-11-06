module Finix
  class FeeProfile
    include Finix::Resource
    include Finix::HypermediaRegistry

    define_hypermedia_types [:fee_profiles]
  end
end
