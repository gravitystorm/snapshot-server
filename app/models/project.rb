# == Schema Information
#
# Table name: projects
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  loaded     :boolean         default(FALSE), not null
#  created_at :datetime
#  updated_at :datetime
#

class Project < ActiveRecord::Base

  validates :title, :presence => true, :uniqueness => true
  has_many :nodes, :class_name => "ProjectNode"
  has_many :relations, :class_name => "ProjectRelation"
  has_many :relation_members, :class_name => "ProjectRelationMember"
  has_many :way_nodes, :class_name => "ProjectWayNode"
  has_many :ways, :class_name => "ProjectWay"
  has_many :users, :class_name => "ProjectUser"

  def tagged_completion
    entities = self.nodes.with_tags.count + self.ways.with_tags.count + self.relations.with_tags.count
    changes = self.nodes.with_tags.status_changed.count + self.ways.with_tags.status_changed.count + self.relations.with_tags.status_changed.count
    entities > 0 ? ((changes.to_f / entities) * 100).to_i : 0
  end

  # This uses raw sql queries, which isn't very rails-y, but at least scales exteremly well.
  # An alternative would be to investigate gems like https://github.com/zdennis/activerecord-import
  def transfer
    self.connection.execute(
      "INSERT INTO project_nodes
        (project_id,osm_id,version,user_id,tstamp,changeset_id,tags,geom)
        SELECT #{self.id},id,version,user_id,tstamp,changeset_id,tags,geom FROM nodes;")

    self.connection.execute(
      "INSERT INTO project_relations
        (project_id,osm_id,version,user_id,tstamp,changeset_id,tags)
        SELECT #{self.id},id,version,user_id,tstamp,changeset_id,tags FROM relations;")

    self.connection.execute(
      "INSERT INTO project_relation_members
        (project_id,relation_id,member_id,member_type,member_role,sequence_id)
        SELECT #{self.id},relation_id,member_id,member_type,member_role,sequence_id FROM relation_members;")

    self.connection.execute(
      "INSERT INTO project_way_nodes
        (project_id, way_id, node_id, sequence_id)
        SELECT #{self.id},way_id, node_id, sequence_id FROM way_nodes;")

    self.connection.execute(
      "INSERT INTO project_ways
        (project_id, osm_id, version, user_id, tstamp,changeset_id, tags)
        SELECT #{self.id}, id, version, user_id, tstamp, changeset_id, tags FROM ways;")

    self.connection.execute(
      "INSERT INTO project_users
        (project_id, osm_id, name)
        SELECT #{self.id}, id, name FROM users;")

    self.update_attribute(:loaded, true)
    self.reload
  end

  def truncate_staging_tables
    self.connection.execute("truncate table nodes")
    self.connection.execute("truncate table relations")
    self.connection.execute("truncate table relation_members")
    self.connection.execute("truncate table way_nodes")
    self.connection.execute("truncate table ways")
    self.connection.execute("truncate table users")
  end

  def min_lat
    self.nodes.minimum("st_y(geom)").to_f
  end

  def min_lon
    self.nodes.minimum("st_x(geom)").to_f
  end

  def max_lat
    self.nodes.maximum("st_y(geom)").to_f
  end

  def max_lon
    self.nodes.maximum("st_x(geom)").to_f
  end

  def avg_lat
    self.nodes.average("st_y(geom)").to_f
  end

  def avg_lon
    self.nodes.average("st_x(geom)").to_f
  end
end
