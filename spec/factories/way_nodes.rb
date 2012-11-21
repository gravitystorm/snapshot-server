FactoryGirl.define do
  factory :way_node do
    sequence(:sequence_id) { |n| n}
    node { FactoryGirl.create(:node) }
    way { FactoryGirl.create(:way) }
  end
end
