class ProjectsController < ApplicationController
  before_filter :load_project, :except => [:index, :new, :create]

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
    @nodes = @project.nodes.with_tags.page(params[:page])
  end

  def tagged_ways
    @ways = @project.ways.with_tags.page(params[:page])
  end

  def tagged_relations
    @relations = @project.relations.with_tags.page(params[:page])
  end

  def transfer
    @project.transfer
    redirect_to @project
  end

  private

  def load_project
    @project = Project.find(params[:id])
  end
end
