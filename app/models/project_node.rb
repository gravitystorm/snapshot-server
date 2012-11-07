# == Schema Information
#
# Table name: project_nodes
#
#  id           :integer         not null, primary key
#  project_id   :integer         not null
#  osm_id       :integer(8)      not null
#  version      :integer         not null
#  user_id      :integer         not null
#  tstamp       :datetime        not null
#  changeset_id :integer(8)      not null
#  tags         :hstore
#  created_at   :datetime
#  updated_at   :datetime
#  geom         :spatial({:srid=
#  status       :text
#

class ProjectNode < ActiveRecord::Base
  require 'xml/libxml'
  require 'osm'

  include Entity

  belongs_to :project
  belongs_to :user, :class_name => "ProjectUser"

  has_many :way_nodes, :class_name => "ProjectWayNode", :foreign_key => "node_id", :primary_key => "osm_id", :conditions => proc {"project_way_nodes.project_id = #{project_id}"}
  has_many :ways, :class_name => "ProjectWay", :through => :way_nodes

  validates :project_id, :presence => true
  validates :osm_id, :presence => true
  validates :version, :presence => true
  validates :user_id, :presence => true
  validates :tstamp, :presence => true
  validates :changeset_id, :presence => true

  def self.default_status
    NODE_STATUS_DEFAULT
  end

  def update_from(node)
    self.osm_id = node.id
    self.version = node.version
    self.user_id = node.user_id
    self.tstamp = node.tstamp
    self.changeset_id = node.changeset_id
    self.tags = node.tags
    self.geom = node.geom
  end

  def to_xml
    doc = OSM::API.new.get_xml_doc
    doc.root << to_xml_node()
    return doc
  end

  def to_xml_node()
    el1 = XML::Node.new 'node'
    el1['id'] = self.osm_id.to_s
    el1['lat'] = self.geom.y.to_s
    el1['lon'] = self.geom.x.to_s
    el1['version'] = self.version.to_s
    el1['changeset'] = self.changeset_id.to_s
    el1['status'] = self.status || NODE_STATUS_DEFAULT
    el1['timestamp'] = self.tstamp.xmlschema

    if self.user
      el1['user'] = self.user.name
      el1['uid'] = self.user_id.to_s
    end

    self.tags.each do |k,v|
      el2 = XML::Node.new('tag')
      el2['k'] = k.to_s
      el2['v'] = v.to_s
      el1 << el2
    end

    return el1
  end

  #
  # Search for nodes matching tags within bounding_box
  #
  # Also adheres to limitations such as within max_number_of_nodes
  #
  def self.search(bounding_box, tags = {})
    min_lon, min_lat, max_lon, max_lat = *bounding_box

    find_by_area(min_lat, min_lon, max_lat, max_lon,
                    :limit => MAX_NUMBER_OF_NODES+1)
  end

  ##
  # the bounding box around a node, which is used for determining the changeset's
  # bounding box
  def bbox
    [ longitude, latitude, longitude, latitude ]
  end

  def self.find_by_area(min_lat, min_lon, max_lat, max_lon, options)
    self.with_scope(:find => {:conditions => ["st_intersects(geom, st_setsrid(box3d('BOX3D(? ?, ? ?)'),4326))", min_lon, min_lat, max_lon, max_lat]}) do
      return self.find(:all, options)
    end
  end

  def self.intersects(l)
    where("st_intersects(geom, ?)", [l])
  end
end
