# Migrating the Bubble Database to Postgres

This project was created to write the tables from an existing Bubble.io app to PostgreSQL database, using Ruby. This project requires some gems like dotenv, httparty, rspec, pg.

With this project you can:

- Export your Bubble.io db schema as a ruby hash or as JSON
- Migrate all the tables present in your Bubble.io app to a PostgreSQL Database
- Populate the imported tables with your data from Bubble.io app
- Automatically create new tables and columns in your PostgreSQL db if you have updated you Bubble.io app
- Automatically create associations (1-to-1 and 1-to-many) based on you Bubble.io app
- Populate the associations created


## How to migrate your Bubble.io Database to a PostgreSQL db

Clone the repo and use the `.env.example` file with your DB infomration and remove the `.example` extension. After that you can pretty much run the command `ruby bin/db_routine_tasks`.

This will fetch and create a schema from your Bubble.io app, and from there it will create the tables. After the tables are created,it will iterate through each table and update the data if there is any data, populate the database with the latest data and then create the associations based on how it's structured in Bubble.

Finally it will populate the associations, connecting the data in the db matching the `_id` from bubble with the `column_name_id` that has the same id.
