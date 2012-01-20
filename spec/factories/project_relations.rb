# == Schema Information
#
# Table name: project_relations
#
#  id           :integer         not null, primary key
#  project_id   :integer         not null
#  osm_id       :integer(8)      not null
#  version      :integer         not null
#  user_id      :integer         not null
#  tstamp       :datetime        not null
#  changeset_id :integer(8)      not null
#  tags         :hstore
#  status       :text
#

FactoryGirl.define do
  factory :project_relation do
    project_id 1
    osm_id 2
    user_id 3
    version 4
    tstamp Time.now
    changeset_id 5
    tags ""

    trait :with_members do
      after_create do |r|
        FactoryGirl.create(:project_relation_member, :relation => r)
        w = FactoryGirl.create(:project_way_with_nodes)
        FactoryGirl.create(:project_relation_member, :relation => r, :member_id => w.osm_id, :member_type => 'W', :member_role => "a long way away")
      end
    end

    factory :project_relation_with_members, :traits => [:with_members]
  end
end
