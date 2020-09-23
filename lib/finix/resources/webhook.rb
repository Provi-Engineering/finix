module Finix
  class Webhook
    include Finix::Resource
    include Finix::HypermediaRegistry

    define_hypermedia_types [:webhooks]
  end
end
