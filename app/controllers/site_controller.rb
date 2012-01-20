class SiteController < ApplicationController
  def index
    @projects = Project.order("created_at desc").limit(5)
  end
end
