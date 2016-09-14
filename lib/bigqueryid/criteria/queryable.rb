module Bigqueryid
  module Criteria
    # Defines behaviour for query operations.
    module Queryable
      extend ActiveSupport::Concern

      class_methods do

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
