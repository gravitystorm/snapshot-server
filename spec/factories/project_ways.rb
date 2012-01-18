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
        FactoryGirl.create_list(:project_way_node, 10, :way => w)
      end
    end

    factory :project_way_with_nodes, :traits => [:with_nodes]
  end
end