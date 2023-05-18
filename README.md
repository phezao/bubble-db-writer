# Migrating the Bubble Database to Postgres

This project was created to write the tables from an existing Bubble.io app to PostgreSQL database, using Ruby. This project requires some gems like dotenv, httparty, rspec, pg.

With this project you can:

- Import your Bubble.io db schema
- Migrate all the tables present in your Bubble.io app to a PostgreSQL Database

## How to migrate your Bubble.io Database to a PostgreSQL db

Clone the repo and use the `.env.example` file with your DB infomration and remove the `.example` extension.

```ruby
require_relative 'lib/bubble_ruby'

db = BubbleRuby::DB.new
```

### Importing the Bubble.io Database tables

Just run `#create` method from your db instance.

```ruby
db.create
```

### Updating the Bubble.io Database tables

You can run `#update` in your db instance.

### Migrating your tables to your PostgreSQL db

Use the method `#migrate` in your db instance.
