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
  validates_numericality_of :id, :on => :update, :integer_only => true
  validates_numericality_of :changeset_id, :version, :integer_only => true

  def self.default_status
    RELATION_STATUS_DEFAULT
  end
  


end
