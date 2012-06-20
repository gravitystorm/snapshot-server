class AddIndexes < ActiveRecord::Migration
  def change
    add_index :project_nodes, :project_id
    add_index :project_nodes, :osm_id

    add_index :project_ways, :project_id
    add_index :project_ways, :osm_id

    add_index :project_relations, :project_id
    add_index :project_relations, :osm_id

    add_index :project_way_nodes, :project_id
    add_index :project_way_nodes, :way_id
    add_index :project_way_nodes, :node_id
  end
end
