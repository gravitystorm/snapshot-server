class WayController < ApplicationController
  require 'xml/libxml'

  skip_before_filter :verify_authenticity_token

  #after_filter :compress_output

  # set the status for the given way
  def status
    @way = Way.find(params[:id])
    @way.status = request.raw_post
    @way.save
    render :text => @way.status
  end
end