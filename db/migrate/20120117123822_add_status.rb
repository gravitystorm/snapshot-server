class AddStatus < ActiveRecord::Migration
  def change
    add_column :project_nodes, :status, :text
    add_column :project_ways, :status, :text
    add_column :project_relations, :status, :text
  end
end
