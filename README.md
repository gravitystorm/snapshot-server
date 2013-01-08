# Snapshot server

A small rails application for taking .osm files and serving OpenStreetMap map-calls.

The data is loaded into the system using osmosis snapshot schema (`--write-pgsql`), although the latest version of the software can handle multiple projects (i.e. multiple .osm files) and so the database schema is slightly modified.

## Installation

This is a rails application, so lots of things will seem familar if you're familiar with rails projects.

### Prerequisites

For an Ubuntu 12.04 LTS server, you need the following packages installed:

```
sudo apt-get install git postgresql-9.1 postgresql-server-dev-9.1 postgresql-9.1-postgis postgresql-contrib-9.1 \
                         ruby1.9.1 ruby1.9.1-dev libxml2-dev libxslt-dev
```

You'll need to install bundler using the gem1.9 binary. Don't install the `ruby-bundler` package, since that uses ruby 1.8

`sudo /usr/bin/gem1.9.1 install bundler`

Of course, if you want to mess around with [rvm](https://rvm.io/) or [rbenv](http://rbenv.org/) or anything like that, feel free!

You also need to create a database role (i.e. user), with superuser priviledges (for installing postgis functions). It's easiest if you create one with the
same username as you are logged in with, e.g. `andy`.

```
andy$ sudo su postgres
postgres$ createuser -s andy
postgres$ exit
andy$
```

If you want to use a different setup for your postgres database, like needing passwords or connecting to a different server, just make a note of your connection details. Don't create any databases at this stage.

### First steps

First, grab the code, using git

```
git clone https://github.com/gravitystorm/snapshot-server.git
```

Then install the gem dependencies. This will install rails and all the components of the rails app that you need.

```
cd snapshot-server
bundle install
```

### Databases
Then sort out the database. Cleverly, the next steps will create the required databases, add the postgis and hstore extensions, and create all the table and indexes automatically.

```
cp config/database.yml.example config/database.yml
nano config/database.yml # Only required if you need to change the connection settings, e.g. for postgresql username and passwords
rake db:create
rake db:migrate
```

If you have problems with the PostGIS functions and tables not being installed into the database, check the `script_dir` paths in `config/database.yml`. If you are using PostgreSQL 9.2, or PostGIS 2.0, you'll need to change the paths.

Now, Launch a webserver.

```
rails server
```

Navigate to e.g. `http://localhost:3000` and you'll see a getting started page. Follow the instructions to set up an account on the site.

## Loading data

At present, loading data is in two stages. First we use osmosis to load the data into the staging tables.

```
osmosis --read-xml --write-pgsql
```

After the data is loaded, you need to create a new project (via the web interface), and transfer the data from the staging tables into that project.

```
rails console
project = Project.last
project.transfer
```

This can take a minute or two, depending on the size of your dataset. You can clear out the staging tables with `project.truncate_staging_tables`.
