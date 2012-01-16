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

  validates :project_id, :presence => true
  validates :way_id, :presence => true
  validates :node_id, :presence => true
  validates :sequence_id, :presence => true
end
