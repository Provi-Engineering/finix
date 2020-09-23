module Finix

  module HypermediaRegistry

    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end

    module ClassMethods

      def define_hypermedia_types(types)
        @hypermedia_types = types.map! do |t|
          t.to_s
        end.sort!.freeze

        @hypermedia_types.each do |type|
          Finix.hypermedia_registry[type] = self
        end
      end

      attr_reader :hypermedia_types
    end

  end

end