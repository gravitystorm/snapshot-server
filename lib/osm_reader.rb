class OsmReader
  require 'xml/libxml'

  def initialize(iofile, project)
    @parser = LibXML::XML::Reader.io(iofile)
    @project = project
  end

  def create_user(user_id, user_name)
    user = @project.users.new(osm_id: user_id, name: user_name)
    user.save!
  end

  def commit
    nodes = []
    ways = []
    relations = []
    user_ids = []
    @current_entity = nil

    while @parser.read do
      next unless ["node", "way", "relation", "tag", "nd", "member"].include? @parser.name
      if @parser.node_type == XML::Reader::TYPE_END_ELEMENT
        if ["node", "way", "relation"].include? @parser.name
          if @current_entity #remove too
            @current_entity.save!
            @current_entity = nil
          end
        end
      else

        case @parser.name
        when "node"
          raise unless @current_entity.nil?
          osm_id = @parser["id"]
          lat = @parser["lat"]
          lon = @parser["lon"]
          geom = "POINT(#{lon} #{lat})"
          version = @parser["version"]
          tstamp = @parser["timestamp"]
          user_id = @parser["uid"]
          user_name = @parser["user"]
          changeset_id = @parser["changeset"]
          create_user(user_id, user_name) unless user_ids.include?(user_id)

          @current_entity = ProjectNode.new(project_id: @project.id, osm_id: osm_id, version: version, user_id: user_id,
                                            tstamp: tstamp, changeset_id: changeset_id, geom: geom)
          if @parser.empty_element?
            @current_entity.save!
            @current_entity = nil
          end
        when "way"
          raise unless @current_entity.nil?
          osm_id = @parser["id"]
          version = @parser["version"]
          tstamp = @parser["timestamp"]
          user_id = @parser["uid"]
          user_name = @parser["user"]
          changeset_id = @parser["changeset"]
          create_user(user_id, user_name) unless user_ids.include?(user_id)

          @current_entity = ProjectWay.new(project_id: @project.id, osm_id: osm_id, version: version, user_id: user_id,
                                           tstamp: tstamp, changeset_id: changeset_id)
          if @parser.empty_element?
            raise
          end
        when "nd"
          raise unless @current_entity.is_a?(ProjectWay)
          sequence_id = @current_entity.way_nodes.length + 1 # start from 1
          node_osm_id = @parser["ref"]
          wn = ProjectWayNode.create!(project_id: @project.id, way_id: @current_entity.osm_id, node_id: node_osm_id, sequence_id: sequence_id)
          @current_entity.way_nodes << wn
        when "tag"
          key = @parser["k"]
          value = @parser["v"]

          if @current_entity #remove when ways and rels are implemented
            @current_entity.tags = @current_entity.tags ? @current_entity.tags.merge({ key => value }) : { key => value }
          end
        end
      end
    end

    @current_entity.save! unless @current_entity.nil?
    return true
  end
end