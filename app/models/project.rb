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

  # This might take a while...
  def transfer
    Node.all.each do |node|
      pn = self.nodes.new
      pn.update_from(node)
      pn.save!
    end

    Relation.all.each do |relation|
      pr = self.relations.new
      pr.update_from(relation)
      pr.save!
    end

    RelationMember.all.each do |relation_member|
      prm = self.relation_members.new
      prm.update_from(relation_member)
      prm.save!
    end

    WayNode.all.each do |way_node|
      pwn = self.way_nodes.new
      pwn.update_from(way_node)
      pwn.save!
    end

    Way.all.each do |way|
      pw = self.ways.new
      pw.update_from(way)
      pw.save!
    end

    User.all.each do |user|
      pu = self.users.new
      pu.update_from(user)
      pu.save!
    end
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
