class Node < ActiveRecord::Base
  require 'xml/libxml'
  require 'osm'

  has_many :way_nodes
  has_many :ways, :through => :way_nodes

  belongs_to :user
  
  validates_presence_of :id, :on => :update
  validates_presence_of :tstamp, :version,  :changeset_id
  validates_uniqueness_of :id
  validates_numericality_of :changeset_id, :version, :integer_only => true
  validates_numericality_of :id, :on => :update, :integer_only => true

  # Sanity check the latitude and longitude and add an error if it's broken
  def validate_position
    errors.add_to_base("Node is not in the world") unless in_world?
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
 
  def to_xml
    doc = OSM::API.new.get_xml_doc
    doc.root << to_xml_node()
    return doc
  end

  def to_xml_node(changeset_cache = {}, user_display_name_cache = {})
    el1 = XML::Node.new 'node'
    el1['id'] = self.id.to_s
    el1['lat'] = self.geom.y.to_s
    el1['lon'] = self.geom.x.to_s
    el1['version'] = self.version.to_s
    el1['changeset'] = self.changeset_id.to_s

    if self.user
      el1['user'] = self.user.name
      el1['uid'] = self.user_id.to_s
    end

    el1['status'] = ["complete", "incomplete"].choice

    self.tags.each do |k,v|
      el2 = XML::Node.new('tag')
      el2['k'] = k.to_s
      el2['v'] = v.to_s
      el1 << el2
    end

    el1['timestamp'] = self.tstamp.xmlschema
    return el1
  end


  def self.find_by_area(min_lat, min_lon, max_lat, max_lon, options)
    self.with_scope(:find => {:conditions => ["ST_INTERSECTS(geom, setSrid(box3d('BOX3D(? ?, ? ?)'),4326))", min_lon, min_lat, max_lon, max_lat]}) do
      return self.find(:all, options)
    end
  end

end
