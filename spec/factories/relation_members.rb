FactoryGirl.define do
  factory :relation_member do
    relation { FactoryGirl.create(:relation) }
    sequence(:sequence_id) { |n| n}

    member_id { FactoryGirl.create(:node).id }
    member_type 'N'
    member_role 'nothing in particular'
  end
end
