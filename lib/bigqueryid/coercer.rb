module Bigqueryid
  class Coercer
    attr_reader :coercer, :schema

    def initialize(schema, coercer = Coercible::Coercer.new)
      @coercer = coercer
      @schema  = schema
    end

    def coerce(name, value)
      return value if value.nil? || !has_type?(name)

      coerce_by_type(value, schema[name.to_s][:type])
    end

    private

    def has_type?(name)
      schema.include?(name.to_s) &&
        schema[name.to_s].include?(:type)
    end

    def coerce_by_type(value, type)
      case
        when Array == type || Array === type then coerce_array(value, type)
        when Hash  == type || Hash  === type then coerce_hash(value, type)
        when type == Time  then coerce_time(value)
        else coerce_other(value, type)
      end
    end

    def coerce_array(value, type)
      # type: generic Array
      if type == Array
        coerce_other(value, type)
      # type: Array[Something]
      elsif value.respond_to?(:map)
        value.map do |element|
          coerce_by_type(element, type[0])
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
        value.to_h.map { |k,v| [coerce_by_type(k, k_type), coerce_by_type(v, v_type)] }.to_h
      else
        raise ArgumentError.new "Invalid coercion: #{value.class} => #{type}"
      end
    end

    def coerce_time(value)
      case value
      when Integer, Float      then Time.at(value)
      when /\d{4}-\d{2}-\d{2}/ then Time.parse(value)
      when /\A\d+(\.\d+)?/     then Time.at(value.to_f)
      else value
      end
    end

    def coerce_other(value, type)
      coercer[value.class].send("to_#{type.to_s.downcase}", value)
    end
  end
end
