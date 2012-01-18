# == Schema Information
#
# Table name: project_ways
#
#  id           :integer         not null, primary key
#  project_id   :integer         not null
#  osm_id       :integer(8)
#  version      :integer         not null
#  user_id      :integer         not null
#  tstamp       :datetime        not null
#  changeset_id :integer(8)      not null
#  tags         :hstore
#  status       :text
#

class ProjectWay < ActiveRecord::Base
  include Entity

  belongs_to :project
  has_many :way_nodes, :class_name => "ProjectWayNode", :foreign_key => "way_id"
  has_many :nodes, :through => :way_nodes

  validates :osm_id, :presence => true
  validates :version, :presence => true
  validates :user_id, :presence => true
  validates :tstamp, :presence => true
  validates :changeset_id, :presence => true

  def self.default_status
    WAY_STATUS_DEFAULT
  end

  def update_from(way)
    self.osm_id = way.id
    self.version = way.version
    self.user_id = way.user_id
    self.tstamp = way.tstamp
    self.changeset_id = way.changeset_id
    self.tags = way.tags
  end

  def to_xml
    doc = OSM::API.new.get_xml_doc
    doc.root << to_xml_node()
    return doc
  end

  def to_xml_node(visible_nodes = nil, changeset_cache = {}, user_display_name_cache = {})
    el1 = XML::Node.new 'way'
    el1['id'] = self.osm_id.to_s
    el1['timestamp'] = self.tstamp.xmlschema
    el1['version'] = self.version.to_s
    el1['changeset'] = self.changeset_id.to_s

    if self.user
      el1['user'] = self.user.name
      el1['uid'] = self.user_id.to_s
    end

    el1['status'] = self.status || WAY_STATUS_DEFAULT

    # make sure nodes are output in sequence_id order
    ordered_nodes = []
    self.way_nodes.each do |nd|
      if visible_nodes
        # if there is a list of visible nodes then use that to weed out deleted nodes
        if visible_nodes[nd.node_id]
          ordered_nodes[nd.sequence_id] = nd.node_id.to_s
        end
      else
        # otherwise, manually go to the db to check things
        if nd.node and nd.node.visible?
          ordered_nodes[nd.sequence_id] = nd.node_id.to_s
        end
      end
    end

    ordered_nodes.each do |nd_id|
      if nd_id and nd_id != '0'
        e = XML::Node.new 'nd'
        e['ref'] = nd_id
        el1 << e
      end
    end

    self.tags.each do |k,v|
      e = XML::Node.new 'tag'
      e['k'] = k
      e['v'] = v
      el1 << e
    end
    return el1
  end

  def nds
    unless @nds
      @nds = Array.new
      self.way_nodes.each do |nd|
        @nds += [nd.node_id]
      end
    end
    @nds
  end

  ##
  # the integer coords (i.e: unscaled) bounding box of the way, assuming
  # straight line segments.
  def bbox
    lons = nodes.collect { |n| n.longitude }
    lats = nodes.collect { |n| n.latitude }
    [ lons.min, lats.min, lons.max, lats.max ]
  end
end
