# == Schema Information
#
# Table name: project_relations
#
#  id           :integer         not null, primary key
#  project_id   :integer         not null
#  osm_id       :integer(8)      not null
#  version      :integer         not null
#  user_id      :integer         not null
#  tstamp       :datetime        not null
#  changeset_id :integer(8)      not null
#  tags         :hstore
#  status       :text
#

class ProjectRelation < ActiveRecord::Base
  include Entity

  belongs_to :project
  has_many :relation_members, :class_name => "ProjectRelationMember", :order => 'sequence_id', :foreign_key => "relation_id"
  has_many :containing_relation_members, :class_name => "ProjectRelationMember", :as => :member, :foreign_key => "relation_id"
  has_many :containing_relations, :class_name => "ProjectRelation", :through => :containing_relation_members, :source => :relation, :foreign_key => "relation_id"

  validates :project_id, :presence => true
  validates :osm_id, :presence => true
  validates :version, :presence => true
  validates :user_id, :presence => true
  validates :tstamp, :presence => true
  validates :changeset_id, :presence => true

  def self.default_status
    RELATION_STATUS_DEFAULT
  end

  def update_from(relation)
    self.osm_id = relation.id
    self.version = relation.version
    self.user_id = relation.user_id
    self.tstamp = relation.tstamp
    self.changeset_id = relation.changeset_id
    self.tags = relation.tags
  end

  TYPES = {'N' => "node", 'W' => "way", 'R' => "relation"}

  def to_xml
    doc = OSM::API.new.get_xml_doc
    doc.root << to_xml_node()
    return doc
  end

  def to_xml_node(visible_members = nil, changeset_cache = {}, user_display_name_cache = {})
    el1 = XML::Node.new 'relation'
    el1['id'] = self.osm_id.to_s
    el1['timestamp'] = self.tstamp.xmlschema
    el1['version'] = self.version.to_s
    el1['changeset'] = self.changeset_id.to_s

    if self.user
      el1['user'] = self.user.name
      el1['uid'] = self.user_id.to_s
    end

    self.relation_members.each do |member|
      e = XML::Node.new 'member'
      e['type'] = TYPES[member.member_type].downcase
      e['ref'] = member.member_id.to_s
      e['role'] = member.member_role
      el1 << e
    end

    self.tags.each do |k,v|
      e = XML::Node.new 'tag'
      e['k'] = k
      e['v'] = v
      el1 << e
    end
    return el1
  end

  def self.find_for_nodes(ids, options = {})
    if ids.empty?
      return []
    else
      self.with_scope(:find => { :joins => "INNER JOIN project_relation_members AS rm ON rm.relation_id = project_relations.id", :conditions => "rm.member_type = 'N' AND rm.member_id IN (#{ids.join(',')})" }) do
        return self.find(:all, options)
      end
    end
  end

  def self.find_for_ways(ids, options = {})
    if ids.empty?
      return []
    else
      self.with_scope(:find => { :joins => "INNER JOIN project_relation_members AS rm ON rm.relation_id = project_relations.id", :conditions => "rm.member_type = 'W' AND rm.member_id IN (#{ids.join(',')})" }) do
        return self.find(:all, options)
      end
    end
  end

  def self.find_for_relations(ids, options = {})
    if ids.empty?
      return []
    else
      self.with_scope(:find => { :joins => "INNER JOIN project_relation_members AS rm ON rm.relation_id = project_relations.id", :conditions => "rm.member_type = 'R' AND rm.member_id IN (#{ids.join(',')})" }) do
        return self.find(:all, options)
      end
    end
  end
end
