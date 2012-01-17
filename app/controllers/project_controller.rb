class ProjectController < ApplicationController
  before_filter :load_project, :except => :index

  def index
    @projects = Project.all
  end

  def show
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

  def edit
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
