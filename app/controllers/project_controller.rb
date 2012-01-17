class ProjectController < ApplicationController
  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
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

  def transfer
    @project = Project.find(params[:id])
    @project.transfer
    redirect_to @project
  end
end