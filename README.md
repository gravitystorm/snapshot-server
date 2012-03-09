# Snapshot server

A small rails application for taking .osm files and serving OpenStreetMap map-calls.

The data is loaded into the system using osmosis snapshot schema (`--write-pgsql`), although the latest version of the software can handle multiple projects (i.e. multiple .osm files) and so the database schema is slightly modified.

## Installation

This is a rails application, so lots of things will seem familar if you're familiar with rails projects.

### First steps

First, grab the code

```
git fetch https://github.com/gravitystorm/snapshot-server.git
```

Then install the gem dependencies. You'll need ruby and postgis installed, and development headers for postgres and imagemagick.

```
cd snapshot-server
bundle install
```

### Databases
Then sort out the database

```
cp config/example.database.yml config/database.yml
nano config/database.yml # Put your username and password in here, and pick names for the databases
rake db:create
rake db:migrate
```

Launch a webserver

```
rails server
```

... and you're done.

## Loading data

At present, loading data is in two stages. First we use osmosis to load the data into the staging tables.

```
osmosis --read-xml --write-pgsql
```

After the data is loaded, you need to create a new project, and transfer the data from the staging tables into the main tables.

```
rails console
project = Project.last
project.transfer
```

This can take a minute or two, depending on the size of your dataset. You can clear out the staging tables with `project.truncate_staging_tables`.
