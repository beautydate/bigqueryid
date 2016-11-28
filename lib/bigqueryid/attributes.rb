module Bigqueryid
  # Define behaviour to attributes of entity.
  module Attributes
    extend ActiveSupport::Concern

    included do
      class_attribute :attributes

      self.attributes = {}

      field :id

      def attributes=(attributes)
        if attributes.is_a? ::Hash
          attributes.each_pair { |key, value| send("#{key}=", value) }
        else
          raise Bigqueryid::Errors::BigqueryError.new 'Attributes params must be a Hash'
        end
      rescue
        raise Bigqueryid::Errors::BigqueryError.new 'Attribute invalid'
      end

      def attributes_names
        attributes.keys
      end

      def set_default_values
        attributes.each_pair do |name, options|
          next unless options.key? :default

          default = options[:default]
          # Default might be a lambda
          value = default.respond_to?(:call) ? default.call : default
          send("#{name}=", value)
        end
      end

      def to_hash
        hash = {}
        attributes_names.each do |property|
          hash[property] = send(property)
        end
        hash.sort.to_h
      end

      def coercer
        @coercer ||= Coercible::Coercer.new
      end
    end

    class_methods do
      protected

      def field(name, options = {})
        add_field(name.to_s, options)
      end

      def add_field(name, options)
        attributes[name] = options
        create_accessors(name)
      end

      # https://www.leighhalliday.com/ruby-metaprogramming-creating-methods
      def create_accessors(name)
        define_method(name) do # Define get method
          instance_variable_get("@#{name}")
        end

        define_method("#{name}=") do |value| # Define set method
          coerced_value =
            if attributes[name][:type]
              coercer[value.class].send("to_#{attributes[name][:type].to_s.downcase}", value)
            else
              value
            end

          instance_variable_set("@#{name}", coerced_value)
        end
      end
    end
  end
end
