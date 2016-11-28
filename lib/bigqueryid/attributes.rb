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

      def coerce(value, type)
        if value.nil? || !type
          value
        else
          case
          when Array == type || Array === type then coerce_array(value, type)
          when Hash  == type || Hash  === type then coerce_hash(value, type)
          when type == Time  then coerce_time(value)
          else coerce_other(value, type)
          end
        end
      end


      def coerce_array(value, type)
        # type: generic Array
        if type == Array
          coerce_other(value, type)
        # type: Array[Something]
        elsif value.respond_to?(:map)
          value.map do |element|
            coerce(element, type[0])
          end
        else
          raise ArgumentError.new "Invalid coercion: #{value.class} => #{type}"
        end
      end

      def coerce_hash(value, type)
        # type: generic Hash
        if type == Hash
          coerce_other(value, type)
        # type: Hash[Something => Other thing]
        elsif value.respond_to?(:to_h)
          k_type, v_type = type.to_a[0]
          value.to_h.map{ |k,v| [ coerce(k, k_type), coerce(v, v_type) ] }.to_h
        else
          raise ArgumentError.new "Invalid coercion: #{value.class} => #{type}"
        end
      end

      def coerce_time(value)
        case value
        when Integer then Time.at(value)
        when String then Time.parse(value)
        else value
        end
      end

      def coerce_other(value, type)
        coercer[value.class].send("to_#{type.to_s.downcase}", value)
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
          instance_variable_set("@#{name}", coerce(value, attributes[name][:type]))
        end
      end
    end
  end
end
