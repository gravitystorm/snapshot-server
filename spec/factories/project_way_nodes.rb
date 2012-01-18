FactoryGirl.define do
  factory :project_way_node do
    project_id 1
    sequence(:sequence_id) { |n| n}
    node { FactoryGirl.create(:project_node) }
    way { FactoryGirl.create(:project_way) }
  end
end