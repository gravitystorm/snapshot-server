# == Schema Information
#
# Table name: project_way_nodes
#
#  id          :integer         not null, primary key
#  project_id  :integer         not null
#  way_id      :integer(8)      not null
#  node_id     :integer(8)      not null
#  sequence_id :integer         not null
#

FactoryGirl.define do
  factory :project_way_node do
    project_id 1
    sequence(:sequence_id) { |n| n}
    node { FactoryGirl.create(:project_node, :project_id => project_id) }
    way { FactoryGirl.create(:project_way) }
  end
end
