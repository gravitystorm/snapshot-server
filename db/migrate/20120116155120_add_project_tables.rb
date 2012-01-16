class AddProjectTables < ActiveRecord::Migration
  def up
    create_table :projects do |t|
      t.string :title
      t.boolean :loaded, :default => false, :null => false
      t.timestamps
    end

    create_table :project_nodes do |t|
      t.references :project, :null => false
      t.integer :osm_id, :limit => 8, :null => false
      t.integer :version, :null => false
      t.integer :user_id, :null => false
      t.timestamp :tstamp, :null => false
      t.integer :changeset_id, :limit => 8, :null => false
      t.hstore :tags
      t.point :geom, :srid => 4326
      t.timestamps
    end

    create_table :project_relation_members do |t|
      t.references :project, :null => false
      t.integer :relation_id, :limit => 8, :null => false
      t.integer :member_id, :limit => 8, :null => false
      t.string :member_type, :limit => 1, :null => false
      t.text :member_role, :null => false
      t.integer :sequence_id, :null => false
    end

    create_table :project_relations do |t|
      t.references :project, :null => false
      t.integer :osm_id, :limit => 8, :null => false
      t.integer :id, :limit => 8, :null => false
      t.integer :version, :null => false
      t.integer :user_id, :null => false
      t.timestamp :tstamp, :null => false
      t.integer :changeset_id, :limit => 8, :null => false
      t.hstore :tags
    end

    create_table :project_users do |t|
      t.references :project, :null => false
      t.integer :osm_id, :null => false
      t.text :name, :null => false
    end

    create_table :project_way_nodes do |t|
      t.references :project, :null => false
      t.integer :way_id, :limit => 8, :null => false
      t.integer :node_id, :limit => 8, :null => false
      t.integer :sequence_id, :null => false
    end

    create_table :project_ways do |t|
      t.references :project, :null => false
      t.integer :osm_id, :limit => 8
      t.integer :version, :null => false
      t.integer :user_id, :null => false
      t.timestamp :tstamp, :null => false
      t.integer :changeset_id, :limit => 8, :null => false
      t.hstore :tags
    end
  end

  def down
    drop_table :projects
    drop_table :project_nodes
    drop_table :project_relation_members
    drop_table :project_relations
    drop_table :project_users
    drop_table :project_way_nodes
    drop_table :project_ways
  end
end
