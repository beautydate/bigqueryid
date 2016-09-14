module Bigqueryid
  # Inject behaviour for query operations.
  module Criteria
    extend ActiveSupport::Concern

    include Queryable
  end
end
