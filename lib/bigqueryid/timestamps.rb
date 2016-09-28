module Bigqueryid
  # Define behaviour to created_at and updated_at data
  module Timestamps
    extend ActiveSupport::Concern

    included do
      field :created_at, default: DateTime.now
    end
  end
end
