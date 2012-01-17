class SiteController < ApplicationController
  def index
    @projects = Project.all
  end
end
