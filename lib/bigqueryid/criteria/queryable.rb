module Bigqueryid
  module Criteria
    # Defines behaviour for query operations.
    module Queryable
      extend ActiveSupport::Concern

      class_methods do

        def where(filter)
          return [] if filter.empty?

          where = []
          filter.each do |key, value|
            filter[key] = coercer.coerce(key, value)
            where << "#{key} = @#{key}"
          end

          query = "SELECT * FROM #{dataset_name}.#{table_name}" \
                  " WHERE #{where.join(' AND ')}"

          result = bigquery.query(query, params: filter)
          result.map do |row|
            new(row.select { |f| attributes.include?(f) })
          end
        end

        def run(query)
          result = bigquery.query query
          new(result.first) if result.count == 1
        end

        def fetch(query)
          result = bigquery.query query
          if result.count > 0
            result.map { |element| new(element) }
          else
            []
          end
        end
      end
    end
  end
end
