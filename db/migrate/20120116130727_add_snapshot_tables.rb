class AddSnapshotTables < ActiveRecord::Migration
  def up
    create_table :nodes, :id => false do |t|
      t.integer :id, :limit => 8, :null => false
      t.integer :version, :null => false
      t.integer :user_id, :null => false
      t.timestamp :tstamp, :null => false
      t.integer :changeset_id, :limit => 8, :null => false
      t.hstore :tags
      t.point :geom, :srid => 4326
    end

    create_table :relation_members, :id => false do |t|
      t.integer :relation_id, :limit => 8, :null => false
      t.integer :member_id, :limit => 8, :null => false
      t.string :member_type, :limit => 1, :null => false
      t.text :member_role, :null => false
      t.integer :sequence_id, :null => false
    end

    create_table :relations, :id => false do |t|
      t.integer :id, :limit => 8, :null => false
      t.integer :version, :null => false
      t.integer :user_id, :null => false
      t.timestamp :tstamp, :null => false
      t.integer :changeset_id, :limit => 8, :null => false
      t.hstore :tags
    end

    create_table :users, :id => false do |t|
      t.integer :id, :null => false
      t.text :name, :null => false
    end

    create_table :way_nodes, :id => false do |t|
      t.integer :way_id, :limit => 8, :null => false
      t.integer :node_id, :limit => 8, :null => false
      t.integer :sequence_id, :null => false
    end

    create_table :ways, :id => false do |t|
      t.integer :id, :limit => 8
      t.integer :version, :null => false
      t.integer :user_id, :null => false
      t.timestamp :tstamp, :null => false
      t.integer :changeset_id, :limit => 8, :null => false
      t.hstore :tags
    end

    execute "ALTER TABLE ways ADD COLUMN nodes bigint[]"

    create_table :schema_info, :id => false do |t|
      t.integer :version, :null => false
    end

    execute "INSERT INTO schema_info VALUES (6)"

    execute <<-EOF
      ALTER TABLE ONLY schema_info ADD CONSTRAINT pk_schema_info PRIMARY KEY (version);
      ALTER TABLE ONLY users ADD CONSTRAINT pk_users PRIMARY KEY (id);
      ALTER TABLE ONLY nodes ADD CONSTRAINT pk_nodes PRIMARY KEY (id);
      ALTER TABLE ONLY ways ADD CONSTRAINT pk_ways PRIMARY KEY (id);
      ALTER TABLE ONLY way_nodes ADD CONSTRAINT pk_way_nodes PRIMARY KEY (way_id, sequence_id);
      ALTER TABLE ONLY relations ADD CONSTRAINT pk_relations PRIMARY KEY (id);
      ALTER TABLE ONLY relation_members ADD CONSTRAINT pk_relation_members PRIMARY KEY (relation_id, sequence_id);
      CREATE INDEX idx_nodes_geom ON nodes USING gist (geom);
      CREATE INDEX idx_way_nodes_node_id ON way_nodes USING btree (node_id);
      CREATE INDEX idx_relation_members_member_id_and_type ON relation_members USING btree (member_id, member_type);
    EOF
  end

  def down
    drop_table :nodes
    drop_table :relation_members
    drop_table :relations
    drop_table :users
    drop_table :way_nodes
    drop_table :ways
    drop_table :schema_info
  end
end
