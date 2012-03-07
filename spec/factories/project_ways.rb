# == Schema Information
#
# Table name: project_ways
#
#  id           :integer         not null, primary key
#  project_id   :integer         not null
#  osm_id       :integer(8)
#  version      :integer         not null
#  user_id      :integer         not null
#  tstamp       :datetime        not null
#  changeset_id :integer(8)      not null
#  tags         :hstore
#  status       :text
#

FactoryGirl.define do
  factory :project_way do
    project_id 1
    osm_id 2
    user_id 3
    version 4
    tstamp Time.now
    changeset_id 5
    tags ""

    trait :with_nodes do
      after_create do |w|
        FactoryGirl.create_list(:project_way_node, 10, :way => w, :project_id => w.project_id)
      end
    end

    factory :project_way_with_nodes, :traits => [:with_nodes]
  end
end