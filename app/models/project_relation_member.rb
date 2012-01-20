# == Schema Information
#
# Table name: project_relation_members
#
#  id          :integer         not null, primary key
#  project_id  :integer         not null
#  relation_id :integer(8)      not null
#  member_id   :integer(8)      not null
#  member_type :string(1)       not null
#  member_role :text            not null
#  sequence_id :integer         not null
#

class ProjectRelationMember < ActiveRecord::Base
  belongs_to :project

  belongs_to :relation, :class_name => "ProjectRelation", :primary_key => "osm_id", :conditions => proc {"project_relations.project_id = #{project_id}"}

  validates :project_id, :presence => true
  validates :relation_id, :presence => true
  validates :member_id, :presence => true
  validates :member_type, :presence => true
  validates :sequence_id, :presence => true

  def update_from(rm)
    self.relation_id = rm.relation_id
    self.member_id = rm.member_id
    self.member_type = rm.member_type
    self.member_role = rm.member_role
    self.sequence_id = rm.sequence_id
  end
end
