class Api::WayController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :load_way

  def show
    if @way
      response.headers['Last-Modified'] = @way.tstamp.rfc822
      render :text => @way.to_xml.to_s, :content_type => "text/xml"
    else
      render :text => "", :status => :gone
    end
  end

  # set the status for the given way
  def status
    @way.status = request.raw_post
    @way.save!
    render :text => @way.status
  end

  def load_way
    @project = Project.find(params[:project_id])
    @way = @project.ways.find_by_osm_id(params[:id])
  end
end
