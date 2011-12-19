class SiteController < ApplicationController
  def index
    @node_count = Node.count
    @way_count = Way.count
    @rel_count = Relation.count
  end
end
