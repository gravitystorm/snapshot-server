class AddStatus < ActiveRecord::Migration
  def self.up
    add_column :nodes, :status, :string
    add_column :ways, :status, :string
    add_column :relations, :status, :string
  end

  def self.down
    remove_column :nodes, :status
    remove_column :ways, :status
    remove_column :relations, :status
  end
end
