# == Schema Information
#
# Table name: ways
#
#  id           :integer(8)      not null, primary key
#  version      :integer         not null
#  user_id      :integer         not null
#  tstamp       :datetime        not null
#  changeset_id :integer(8)      not null
#  tags         :hstore
#  nodes        :string(8)
#

class Way < ActiveRecord::Base

  include Entity
  
  has_many :way_nodes, :order => 'sequence_id'
  has_many :nodes, :through => :way_nodes, :order => 'sequence_id'

  has_many :containing_relation_members, :class_name => "RelationMember", :as => :member
  has_many :containing_relations, :class_name => "Relation", :through => :containing_relation_members, :source => :relation

  validates_presence_of :id, :on => :update
  validates_presence_of :changeset_id,:version,  :tstamp
  validates_uniqueness_of :id
  validates_numericality_of :changeset_id, :version, :integer_only => true
  validates_numericality_of :id, :on => :update, :integer_only => true
end
