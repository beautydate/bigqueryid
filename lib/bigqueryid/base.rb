require 'active_support/concern'
# BigQuery DSL
module Bigqueryid
  # Inject class methods in BigQuery Model
  module Base
    extend ActiveSupport::Concern

    include Attributes
    include Criteria

    include Base::Initializable

    included do
      class_attribute :dataset_name
      class_attribute :table_name

      def self.dataset(name)
        self.dataset_name = name
      end

      def self.table(name)
        self.table_name = name
      end

      def self.gcloud
        Google::Cloud.new
      end

      def self.bigquery
        @bigquery_connection ||= gcloud.bigquery
      end

      def self.gcloud_table
        bigquery.dataset(dataset_name).table(table_name)
      end

      def self.table_exist?
        gcloud_table ? true : false
      end

      def self.delete_table
        gcloud_table.delete if table_exist?
      end

      def self.flush
        delete_table
        create_table
      end

      def self.load_data_from_csv(gs_url)
        job = gcloud_table.load gs_url
      end

      def self.run(query_string)
        bigquery.query query_string
      end
    end
  end
end
