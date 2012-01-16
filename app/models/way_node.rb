# == Schema Information
#
# Table name: way_nodes
#
#  way_id      :integer(8)      not null, primary key
#  node_id     :integer(8)      not null
#  sequence_id :integer         not null
#

class WayNode < ActiveRecord::Base

  belongs_to :node

  belongs_to :way
end
