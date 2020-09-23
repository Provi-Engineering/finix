module Finix
  class IndifferentHash < ::Hash
    def method_missing(method, *args, &block)
      if self.has_key? "#{method}"
        value = self["#{method}"]
        result = value.call
        # result.init! args.slice(0) if result.respond_to? :init!
        return result
      end
    end
  end
end
