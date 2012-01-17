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
  has_many :users, :class_name => "ProjectUsers"

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
end