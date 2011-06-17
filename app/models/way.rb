class Way < ActiveRecord::Base
  require 'xml/libxml'
 
  belongs_to :user
  
  has_many :way_nodes, :order => 'sequence_id'
  has_many :nodes, :through => :way_nodes, :order => 'sequence_id'

  has_many :containing_relation_members, :class_name => "RelationMember", :as => :member
  has_many :containing_relations, :class_name => "Relation", :through => :containing_relation_members, :source => :relation

  validates_presence_of :id, :on => :update
  validates_presence_of :changeset_id,:version,  :tstamp
  validates_uniqueness_of :id
  validates_numericality_of :changeset_id, :version, :integer_only => true
  validates_numericality_of :id, :on => :update, :integer_only => true

  # Find a way given it's ID, and in a single SQL call also grab its nodes and tags
  def to_xml
    doc = OSM::API.new.get_xml_doc
    doc.root << to_xml_node()
    return doc
  end

  def to_xml_node(visible_nodes = nil, changeset_cache = {}, user_display_name_cache = {})
    el1 = XML::Node.new 'way'
    el1['id'] = self.id.to_s
    el1['timestamp'] = self.tstamp.xmlschema
    el1['version'] = self.version.to_s
    el1['changeset'] = self.changeset_id.to_s

    if self.user
      el1['user'] = self.user.name
      el1['uid'] = self.user_id.to_s
    end


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
