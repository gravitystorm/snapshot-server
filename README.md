# Snapshot server

A small rails application for taking .osm files and serving OpenStreetMap map-calls.

The data is loaded into the system using osmosis snapshot schema (`--write-pgsql`), although the latest version of the software can handle multiple projects (i.e. multiple .osm files) and so the database schema is slightly modified.

## Installation

This is a rails application, so lots of things will seem familar if you're familiar with rails projects.

### First steps

First, grab the code

```
git clone https://github.com/gravitystorm/snapshot-server.git
```

Then install the gem dependencies. You'll need ruby and postgis installed, and development headers for postgres.

```
cd snapshot-server
bundle install
```

### Databases
Then sort out the database

```
cp config/database.yml.example config/database.yml
nano config/database.yml # Put your username and password in here, and pick names for the databases
```
Create both databases with either ```createdb``` or ```rake db:create```

Install PostGIS and hstore to the -dev database. For postgresql 9.1 with postgis 2.0

```
psql -d snapshot-dev -c "CREATE EXTENSION hstore; CREATE EXTENSION postgis;"
```

Load the schema
```
rake db:schema:load
```

Launch a webserver

```
rails server
```

... and you're done.

## Loading data

At present, loading data is in two stages. First we use osmosis to load the data into the staging tables.

```
psql -d snapshot-dev -f pgsnapshot_schema_0.6.sql
osmosis --read-xml --write-pgsql
```


After the data is loaded, you need to create a new project, and transfer the data from the staging tables into the main tables.

```
rails console
project = Project.last
project.transfer
```

This can take an hour or two, depending on the size of your dataset. You can clear out the staging tables with `project.truncate_staging_tables`.

### Alternate data loading method

An alternate method to load data is directly running postgresql queries. This is trickier than using hte rails console but is much faster for larger datasets.

The following SQL will load data from the staging tables into project 2. If you are not careful it is easy to screw up your data.

```
INSERT INTO project_nodes (project_id,osm_id,version,user_id,tstamp,changeset_id,tags,geom)
SELECT 2,id,version,user_id,tstamp,changeset_id,tags,geom FROM nodes;

INSERT INTO project_relations (project_id,osm_id,version,user_id,tstamp,changeset_id,tags,status)
SELECT 2,id,version,user_id,tstamp,changeset_id,tags,'incomplete' FROM relations;

INSERT INTO project_relation_members (project_id,relation_id,member_id,member_type,member_role,sequence_id)
SELECT 2,relation_id,member_id,member_type,member_role,sequence_id FROM relation_members;

INSERT INTO project_way_nodes (project_id, way_id, node_id, sequence_id)
SELECT 2,way_id, node_id, sequence_id FROM way_nodes;

INSERT INTO project_ways (project_id, osm_id, version, user_id, tstamp, changeset_id, tags, status)
SELECT 2, id, version, user_id, tstamp, changeset_id, tags, 'incomplete' FROM ways;

INSERT INTO project_users (project_id, osm_id, name)
SELECT 2, id, name FROM users; 

ANALYZE;
```
