# == Schema Information
#
# Table name: project_nodes
#
#  id           :integer         not null, primary key
#  project_id   :integer         not null
#  osm_id       :integer(8)      not null
#  version      :integer         not null
#  user_id      :integer         not null
#  tstamp       :datetime        not null
#  changeset_id :integer(8)      not null
#  tags         :hstore
#  created_at   :datetime
#  updated_at   :datetime
#  geom         :spatial({:srid=
#  status       :text
#

class ProjectNode < ActiveRecord::Base
  include Entity

  belongs_to :project

  validates :project_id, :presence => true
  validates :osm_id, :presence => true
  validates :version, :presence => true
  validates :user_id, :presence => true
  validates :tstamp, :presence => true
  validates :changeset_id, :presence => true

  def self.default_status
    NODE_STATUS_DEFAULT
  end

  def update_from(node)
    self.osm_id = node.id
    self.version = node.version
    self.user_id = node.user_id
    self.tstamp = node.tstamp
    self.changeset_id = node.changeset_id
    self.tags = node.tags
    self.geom = node.geom
  end
end
