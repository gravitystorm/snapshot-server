class NodesController < ApplicationController
  def show
    @project = Project.find(params[:project_id])
    @relation = @project.relations.find(params[:id])
  end
end