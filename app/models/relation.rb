# == Schema Information
#
# Table name: relations
#
#  id           :integer(8)      not null, primary key
#  version      :integer         not null
#  user_id      :integer         not null
#  tstamp       :datetime        not null
#  changeset_id :integer(8)      not null
#  tags         :hstore
#

class Relation < ActiveRecord::Base
  require 'xml/libxml'

  include Entity

  has_many :relation_members, :order => 'sequence_id'

  has_many :containing_relation_members, :class_name => "RelationMember", :as => :member
  has_many :containing_relations, :class_name => "Relation", :through => :containing_relation_members, :source => :relation

  validates_presence_of :id, :on => :update
  validates_presence_of :tstamp,:version,  :changeset_id
  validates_uniqueness_of :id
  validates_inclusion_of :visible, :in => [ true, false ]
  validates_numericality_of :id, :on => :update, :integer_only => true
  validates_numericality_of :changeset_id, :version, :integer_only => true

  def self.default_status
    RELATION_STATUS_DEFAULT
  end
  
  TYPES = {'N' => "node", 'W' => "way", 'R' => "relation"}

  def to_xml
    doc = OSM::API.new.get_xml_doc
    doc.root << to_xml_node()
    return doc
  end

  def to_xml_node(visible_members = nil, changeset_cache = {}, user_display_name_cache = {})
    el1 = XML::Node.new 'relation'
    el1['id'] = self.id.to_s
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
      self.with_scope(:find => { :joins => "INNER JOIN relation_members AS rm ON rm.relation_id = relations.id", :conditions => "rm.member_type = 'N' AND rm.member_id IN (#{ids.join(',')})" }) do
        return self.find(:all, options)
      end
    end
  end

  def self.find_for_ways(ids, options = {})
    if ids.empty?
      return []
    else
      self.with_scope(:find => { :joins => "INNER JOIN relation_members AS rm ON rm.relation_id = relations.id", :conditions => "rm.member_type = 'W' AND rm.member_id IN (#{ids.join(',')})" }) do
        return self.find(:all, options)
      end
    end
  end

  def self.find_for_relations(ids, options = {})
    if ids.empty?
      return []
    else
      self.with_scope(:find => { :joins => "INNER JOIN relation_members AS rm ON rm.relation_id = relations.id", :conditions => "rm.member_type = 'R' AND rm.member_id IN (#{ids.join(',')})" }) do
        return self.find(:all, options)
      end
    end
  end

end
