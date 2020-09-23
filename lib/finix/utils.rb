module Finix
  module Utils
    def eval_class(slf, cls)
      mod = slf.class.name.sub(/::.*/, '') unless slf.kind_of? Class or slf.kind_of? Module
      mod = slf.name.sub(/::.*/, '') if mod.nil?
      name = demodulize cls.name
      self.instance_eval "#{mod}::#{name}"
    end

    def callable(callable_or_not)
      callable_or_not.respond_to?(:call) ? callable_or_not : lambda { callable_or_not }
    end

    def indifferent_read_access(base = {})
      indifferent = Hash.new do |hash, key|
        hash[key.to_s] if key.is_a? Symbol
      end
      base.each_pair do |key, value|
        if value.is_a? Hash
          value = indifferent_read_access value
        elsif value.respond_to? :each
          if value.respond_to? :map!
            value.map! do |v|
              if v.is_a? Hash
                v = indifferent_read_access v
              end
              v
            end
          else
            value.map do |v|
              if v.is_a? Hash
                v = indifferent_read_access v
              end
              v
            end
          end
        end
        indifferent[key.to_s] = value
      end
      indifferent
    end

    def demodulize(class_name_in_module)
      class_name_in_module.to_s.sub(/^.*::/, '')
    end

    extend self
  end
end