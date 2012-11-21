FactoryGirl.define do
  factory :way do
    id 2
    user_id 3
    version 4
    tstamp Time.now
    changeset_id 5
    tags Hash.new

    trait :with_nodes do
      after(:create) do |w|
        FactoryGirl.create_list(:way_node, 10, :way => w)
      end
    end

    factory :way_with_nodes, :traits => [:with_nodes]
  end
end
