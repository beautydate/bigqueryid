module Bigqueryid
  # Define behaviour to created_at and updated_at data
  module Timestamps
    extend ActiveSupport::Concern

    included do
      field :created_at, type: Time, default: -> { Time.now.strftime('%Y-%m-%d %H:%M:%S %Z') }
    end
  end
end
