class Api::MapsController < ApplicationController

  #after_filter :compress_output

  # Help methods for checking boundary sanity and area size
  require 'map_boundary'
  require 'osm'
  include MapBoundary
  include OSM

  def show

    @project = Project.find(params[:project_id])
    # Figure out the bbox
    bbox = params[:bbox]

    unless bbox and bbox.count(',') == 3
      # alternatively: report_error(TEXT['boundary_parameter_required']
      report_error("The parameter bbox is required, and must be of the form min_lon,min_lat,max_lon,max_lat")
      return
    end

    bbox = bbox.split(',')

    min_lon, min_lat, max_lon, max_lat = sanitise_boundaries(bbox)

    # check boundary is sane and area within defined
    # see /config/application.yml
    begin
      check_boundaries(min_lon, min_lat, max_lon, max_lat)
    rescue Exception => err
      report_error(err.message)
      return
    end

    # FIXME um why is this area using a different order for the lat/lon from above???
    @nodes = @project.nodes.find_by_area(min_lat, min_lon, max_lat, max_lon, :limit => MAX_NUMBER_OF_NODES+1)
    # get all the nodes, by tag not yet working, waiting for change from NickB
    # need to be @nodes (instance var) so tests in /spec can be performed
    #@nodes = Node.search(bbox, params[:tag])

    node_ids = @nodes.collect(&:osm_id)
    if node_ids.length > MAX_NUMBER_OF_NODES
      report_error("You requested too many nodes (limit is #{MAX_NUMBER_OF_NODES}). Either request a smaller area, or use planet.osm")
      return
    end
    if node_ids.length == 0
      render :text => "<osm version='#{API_VERSION}' generator='#{GENERATOR}'></osm>", :content_type => "text/xml"
      return
    end

    doc = OSM::API.new.get_xml_doc

    # add bounds
    bounds = XML::Node.new 'bounds'
    bounds['minlat'] = min_lat.to_s
    bounds['minlon'] = min_lon.to_s
    bounds['maxlat'] = max_lat.to_s
    bounds['maxlon'] = max_lon.to_s
    doc.root << bounds

    # get ways
    # find which ways are needed
    ways = Array.new
    if node_ids.length > 0
      way_nodes = @project.way_nodes.find_all_by_node_id(node_ids)
      way_ids = way_nodes.collect { |way_node| way_node.way_id }
      ways = @project.ways.find_all_by_osm_id(way_ids, :include => [:way_nodes])

      list_of_way_nodes = ways.collect { |way|
        way.way_nodes.collect { |way_node| way_node.node_id }
      }
      list_of_way_nodes.flatten!

    else
      list_of_way_nodes = Array.new
    end

    # - [0] in case some thing links to node 0 which doesn't exist. Shouldn't actually ever happen but it does. FIXME: file a ticket for this
    nodes_to_fetch = (list_of_way_nodes.uniq - node_ids) - [0]

    if nodes_to_fetch.length > 0
      @nodes += @project.nodes.find_all_by_osm_id(nodes_to_fetch)
    end

    visible_nodes = {}
    changeset_cache = {}
    user_display_name_cache = {}

    @nodes.each do |node|
      #if node.visible?
        doc.root << node.to_xml_node()
        visible_nodes[node.id] = node
      #end
    end

    way_ids = Array.new
    ways.each do |way|
      #if way.visible?
        doc.root << way.to_xml_node()
        way_ids << way.id
      #end
    end

    relations = @project.relations.find_for_nodes(visible_nodes.keys) +
                @project.relations.find_for_ways(way_ids)

    # we do not normally return the "other" partners referenced by an relation,
    # e.g. if we return a way A that is referenced by relation X, and there's
    # another way B also referenced, that is not returned. But we do make
    # an exception for cases where an relation references another *relation*;
    # in that case we return that as well (but we don't go recursive here)
    relations += @project.relations.find_for_relations(relations.collect { |r| r.id })

    # this "uniq" may be slightly inefficient; it may be better to first collect and output
    # all node-related relations, then find the *not yet covered* way-related ones etc.
    relations.uniq.each do |relation|
      doc.root << relation.to_xml_node(nil, changeset_cache, user_display_name_cache)
    end

    response.headers["Content-Disposition"] = "attachment; filename=\"map.osm\""

    render :text => doc.to_s, :content_type => "text/xml"
  end
end