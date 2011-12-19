class SiteController < ApplicationController
  def index
    @node_count = Node.count
    @way_count = Way.count
    @rel_count = Relation.count

    @tagged_node_count = Node.with_tags.count
    @tagged_way_count = Way.with_tags.count
    @tagged_rel_count = Relation.with_tags.count
  end
end
