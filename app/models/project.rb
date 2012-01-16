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
  has_many :project_nodes
  has_many :project_relations
  has_many :project_relation_members
  has_many :project_way_nodes
  has_many :project_ways
  has_many :project_users

  # This might take a while...
  def transfer
    Node.all.each do |node|
      pn = self.project_nodes.new
      pn.update_from(node)
      pn.save!
    end

    Relation.all.each do |relation|
      pr = self.project_relations.new
      pr.update_from(relation)
      pr.save!
    end

    RelationMember.all.each do |relation_member|
      prm = self.project_relation_members.new
      prm.update_from(relation_member)
      prm.save!
    end

    WayNode.all.each do |way_node|
      pwn = self.project_way_nodes.new
      pwn.update_from(way_node)
      pwn.save!
    end

    Way.all.each do |way|
      pw = self.project_ways.new
      pw.update_from(way)
      pw.save!
    end

    User.all.each do |user|
      pu = self.project_users.new
      pu.update_from(user)
      pu.save!
    end
  end
end