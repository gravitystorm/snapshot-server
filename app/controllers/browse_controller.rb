class BrowseController < ApplicationController

  def tagged_nodes
    @nodes = Node.with_tags.page(params[:page])
  end

  def tagged_ways
    @ways = Way.with_tags.page(params[:page])
  end

  def tagged_relations
    @relations = Relation.with_tags.page(params[:page])
  end
end
