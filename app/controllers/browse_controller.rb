class BrowseController < ApplicationController

  def tagged_nodes
    @nodes = Node.with_tags
  end

  def tagged_ways
    @ways = Way.with_tags
  end

  def tagged_relations
    @relations = Relation.with_tags
  end
end
