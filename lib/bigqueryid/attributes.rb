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
          raise Bigqueryid::Errors::BigqueryError.new 'Attributes params need is Hash'
        end
      rescue
        raise Bigqueryid::Errors::BigqueryError.new 'Attribute invalid'
      end

      def properties_names
        attributes.keys
      end

      def set_default_values
        attributes.each_pair do |name, options|
          send("#{name}=", attributes[name][:default]) if options.key? :default
        end
      end

      def to_hash
        hash = {}
        properties_names.each do |property|
          hash[property] = send(property)
        end
        hash.sort.to_h
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
          instance_variable_set("@#{name}", value)
        end
      end
    end
  end
end
