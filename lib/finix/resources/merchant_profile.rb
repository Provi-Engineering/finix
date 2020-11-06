module Finix
  class MerchantProfile
    include Finix::Resource
    include Finix::HypermediaRegistry

    define_hypermedia_types [:merchant_profiles]
  end
end
