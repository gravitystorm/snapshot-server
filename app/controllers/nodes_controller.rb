class NodesController < ApplicationController
  def show
    @project = Project.find(params[:project_id])
    @node = @project.nodes.find(params[:id])
  end
end