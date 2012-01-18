# == Schema Information
#
# Table name: project_way_nodes
#
#  id          :integer         not null, primary key
#  project_id  :integer         not null
#  way_id      :integer(8)      not null
#  node_id     :integer(8)      not null
#  sequence_id :integer         not null
#

class ProjectWayNode < ActiveRecord::Base
  belongs_to :project
  belongs_to :node, :class_name => "ProjectNode"
  belongs_to :way, :class_name => "ProjectWay"

  validates :project_id, :presence => true
  validates :way_id, :presence => true
  validates :node_id, :presence => true
  validates :sequence_id, :presence => true

  def update_from(way_node)
    self.way_id = way_node.way_id
    self.node_id = way_node.node_id
    self.sequence_id = way_node.sequence_id
  end
end
