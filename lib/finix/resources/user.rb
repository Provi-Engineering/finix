module Finix
  class User
    include Finix::Resource
    include Finix::HypermediaRegistry

    define_hypermedia_types [:users]

    def create_application(attrs = {})
      attrs = attrs.attributes if attrs.is_a?(Finix::Resource)
      self.applications.create(attrs)
    end
  end
end
