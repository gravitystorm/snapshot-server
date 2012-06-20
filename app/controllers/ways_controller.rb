class WaysController < ApplicationController
  def show
    @project = Project.find(params[:project_id])
    @way = @project.ways.find(params[:id])
  end
end