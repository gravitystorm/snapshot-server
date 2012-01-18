FactoryGirl.define do
  factory :project_way do
    project_id 1
    osm_id 2
    user_id 3
    version 4
    tstamp Time.now
    changeset_id 5
    tags ""
  end
end