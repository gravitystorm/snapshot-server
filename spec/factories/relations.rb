FactoryGirl.define do
  factory :relation do
    id 2
    user_id 3
    version 4
    tstamp Time.now
    changeset_id 5
    tags Hash.new

    trait :with_members do
      after(:create) do |r|
        FactoryGirl.create(:relation_member, :relation => r)
        w = FactoryGirl.create(:way_with_nodes)
        FactoryGirl.create(:relation_member, :relation => r, :member_id => w.id, :member_type => 'W', :member_role => "a long way away")
      end
    end

    factory :relation_with_members, :traits => [:with_members]
  end
end
