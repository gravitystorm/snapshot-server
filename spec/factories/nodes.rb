FactoryGirl.define do
  factory :node do
    sequence(:id) { |n| n*1000 }
    user_id 3
    version 4
    tstamp Time.now
    changeset_id 5
    geom "POINT(3 4)"
    tags Hash.new

    factory :node_with_tags do
      tags {{:highway => "residential"}}
    end
  end
end
