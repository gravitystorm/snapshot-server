class AddMoreIndexes < ActiveRecord::Migration
  def change
    add_index :project_nodes, :geom, spatial: true
    add_index :project_nodes, [:project_id, :osm_id], unique: true
    add_index :project_way_nodes, [:project_id, :way_id, :sequence_id],
        unique: true, name: "index_project_way_nodes_on_project_way_seq_ids"
    add_index :project_ways, [:project_id, :osm_id], unique: true
    add_index :project_relation_members, [:project_id, :relation_id, :sequence_id],
        unique: true, name: "index_project_relation_members_on_project_rel_seq_ids"
    add_index :project_relations, [:project_id, :osm_id], unique: true
  end
end
