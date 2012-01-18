# == Schema Information
#
# Table name: project_nodes
#
#  id           :integer         not null, primary key
#  project_id   :integer         not null
#  osm_id       :integer(8)      not null
#  version      :integer         not null
#  user_id      :integer         not null
#  tstamp       :datetime        not null
#  changeset_id :integer(8)      not null
#  tags         :hstore
#  created_at   :datetime
#  updated_at   :datetime
#  geom         :spatial({:srid=
#  status       :text
#

FactoryGirl.define do
  factory :project_node do
    project_id 1
    osm_id 2
    user_id 3
    version 4
    tstamp Time.now
    changeset_id 5
    geom "POINT(3 4)"
    tags ""
  end
end
