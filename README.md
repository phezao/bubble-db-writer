# Migrating the Bubble Database to Postgres

## 1. importing all table names

Go to the App -> Settings -> API and open the console and do this:

```javascript
let table_names = [];
document.querySelectorAll('div.exposes-api.field.caption').forEach(n => {
  table_names.push(n.innerText);
});
```

Go to the Sources tab (next to console) and look for 'Snippets'. Create a new Snippet called `consoleSave.js`. Inside paste the following code:

```javascript
(function(console){

    console.save = function(data, filename){

        if(!data) {
            console.error('Console.save: No data')
            return;
        }

        if(!filename) filename = 'console.json'

        if(typeof data === "object"){
            data = JSON.stringify(data, undefined, 4)
        }

        var blob = new Blob([data], {type: 'text/json'}),
            e    = document.createEvent('MouseEvents'),
            a    = document.createElement('a')

        a.download = filename
        a.href = window.URL.createObjectURL(blob)
        a.dataset.downloadurl =  ['text/json', a.download, a.href].join(':')
        e.initMouseEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null)
        a.dispatchEvent(e)
    }
})(console)
```

Then just execute `console.save(table_names)` in the console and it will download a file called `console.json`.

Open that file and copy the array and paste it in the `tables_name_source.rb`, inside the TABLES_NAME constant.

Substitute your credentials inside the `.env.example` file and remove the `.example`.

## 2. Generating the DB Schema

Once all that is complete, just run in your terminal:

```bash
ruby db_schema_builder.rb
```

This will output a `schema.rb` and a `schema.json` with all the tables and the structure of each table with the data types.

It's worth saying that to simplify and make the process faster, we decided that Array types we would define them as TEXT ARRAY, columns that have empty values would be considered TEXT and Geographical Address as well.

## 3. Migrating the DB Schema to PostgreSQL

Now all you have to do is to run:

```bash
ruby db_table_writer.rb
```

And it will write all tables generated to your postgreSQL database.
