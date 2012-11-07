class ProjectsController < ApplicationController
  before_filter :load_project, :except => [:index, :new, :create, :all_snippets]

  def index
    @projects = Project.all
  end

  def show
    @api_endpoint_url = url_for(:controller => :projects, :action => :show, :id => @project.id, :only_path => false) + '/api/'
    @crossdomain_url = root_url + "crossdomain.xml"

    @node_count = @project.nodes.count
    @way_count = @project.ways.count
    @rel_count = @project.relations.count

    @tagged_node_count = @project.nodes.with_tags.count
    @tagged_way_count = @project.ways.with_tags.count
    @tagged_rel_count = @project.relations.with_tags.count

    @percentage_nodes = @project.nodes.percentage_status_changed
    @percentage_ways = @project.ways.percentage_status_changed
    @percentage_rels = @project.relations.percentage_status_changed
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      set_flash_message(:success)
      redirect_to @project
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update_attributes(params[:project])
      set_flash_message(:success)
      redirect_to @project
    else
      render :edit
    end
  end

  def tagged_nodes
    @nodes = @project.nodes.with_tags.ordered.page(params[:page])
  end

  def tagged_ways
    @ways = @project.ways.with_tags.ordered.page(params[:page])
  end

  def tagged_relations
    @relations = @project.relations.with_tags.ordered.page(params[:page])
  end

  def transfer
    @project.transfer
    redirect_to @project
  end

  def all_snippets
    @projects = Project.all
    @crossdomain_url = root_url + "crossdomain.xml"
  end

  def map
    @bounds = [@project.min_lon, @project.min_lat, @project.max_lon, @project.max_lat].join(",")
  end

  def unprocessed
    if params[:bbox]
      bbox = bbox_from_string(params[:bbox], RGeo::Geos.factory(srid: 4326))
      # There's something flakey in here, I think, since the returned list of linestrings isn't quite what
      # I'd expect. Nodes seem to work fine though.
      ways = @project.ways.
                where("array_length(akeys(project_ways.tags), 1) > 0"). # with_tags becomes ambiguous with the intersects
                where("project_ways.status is null or project_ways.status = ?", ProjectWay.default_status). # status becomes ambiguous with the intersects
                intersects(bbox.to_geometry).limit(100)
      nodes = @project.nodes.with_tags.status_unchanged.intersects(bbox.to_geometry).limit(100)
    else
      ways = @project.ways.with_tags.status_unchanged.limit(100)
      nodes = @project.nodes.with_tags.status_unchanged.limit(100)
    end
    entities = [nodes, ways].flatten
    factory = RGeo::GeoJSON::EntityFactory.new
    collection = factory.feature_collection(entities.map { | entity | entity_feature(entity) })
    respond_to do |format|
      format.json { render json: RGeo::GeoJSON.encode(collection)}
    end
  end

  private

  def load_project
    @project = Project.find(params[:id])
  end

  def entity_feature(e)
    e.loc_feature({url: view_context.url_for(e)})
  end
end
