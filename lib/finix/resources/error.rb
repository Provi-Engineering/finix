module Finix
  class Error < ::StandardError
    include Finix::Resource
    include Finix::HypermediaRegistry

    define_hypermedia_types [:errors]

    def message
      @attributes['message']
    end
  end
end
