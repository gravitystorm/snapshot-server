class Api::NodeController < ApplicationController
  require 'xml/libxml'
  before_filter :load_node

  def show
    if @node
      response.headers['Last-Modified'] = @node.tstamp.rfc822
      render :text => @node.to_xml.to_s, :content_type => "text/xml"
    else
      render :text => "", :status => :gone
    end
  end

  # set the status for the given node
  def status
    @node.status = request.raw_post
    @node.save!
    render :text => @node.status
  end

  def load_node
    @project = Project.find(params[:project_id])
    @node = @project.nodes.find_by_osm_id(params[:id])
  end
end