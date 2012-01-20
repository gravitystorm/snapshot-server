# == Schema Information
#
# Table name: nodes
#
#  id           :integer(8)      not null, primary key
#  version      :integer         not null
#  user_id      :integer         not null
#  tstamp       :datetime        not null
#  changeset_id :integer(8)      not null
#  tags         :hstore
#  geom         :spatial({:srid=
#

class Node < ActiveRecord::Base
  require 'xml/libxml'
  require 'osm'

  include Entity

  has_many :way_nodes, :foreign_key => "node_id"
  has_many :ways, :through => :way_nodes
  
  validates_presence_of :id, :on => :update
  validates_presence_of :tstamp, :version,  :changeset_id
  validates_uniqueness_of :id
  validates_numericality_of :changeset_id, :version, :integer_only => true
  validates_numericality_of :id, :on => :update, :integer_only => true

  def self.default_status
    NODE_STATUS_DEFAULT
  end

  # Sanity check the latitude and longitude and add an error if it's broken
  def validate_position
    errors.add_to_base("Node is not in the world") unless in_world?
  end



end
