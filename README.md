# BigQueryID

BigQueryID is an ORM (Object-Relational-Mapper) framework for Google BigQuery in Ruby.

Install
-------
```sh
gem build bigqueryid.gem
gem install bigqueryid-<version>.gem
```
or
```ruby
gem 'bigqueryid', :git => 'git://github.com/fabiotomio/bigqueryid.git'
```

Configure
---------
```sh
export GCLOUD_PROJECT=my-todo-project-id
export GCLOUD_KEYFILE_JSON=/path/to/keyfile.json
```

Use
-------
```ruby
# Define product model product.rb
class Product

  include Bigquery::Base

  dataset 'core'
  table 'products'

  field :name,  type: String
  field :price, type: Float
  field :barcode

  def self.create_table
    bigquery.dataset(self.dataset_name).create_table self.table_name do |schema|
      schema.string 'barcode'
      schema.timestamp 'created_at'
      schema.integer 'id'
      schema.string 'name'
      schema.float 'price'
      schema.timestamp 'updated_at'
    end unless table_exist?
  end

  def self.fetch_all
    sql = <<-SQL.squish
      SELECT
       *
      FROM core.products
      ORDER BY
        P.name
    SQL
    fetch sql
  end
end

# Return if table exists
Product.table_exist?

# Delete table
Product.delete_table

# Delete and create table
Product.flush

# Fetch all rows
Product.fetch_all

```
