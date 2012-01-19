# == Schema Information
#
# Table name: project_relation_members
#
#  id          :integer         not null, primary key
#  project_id  :integer         not null
#  relation_id :integer(8)      not null
#  member_id   :integer(8)      not null
#  member_type :string(1)       not null
#  member_role :text            not null
#  sequence_id :integer         not null
#

FactoryGirl.define do
  factory :project_relation_member do
    project_id 1
    relation { FactoryGirl.create(:project_relation) }
    sequence(:sequence_id) { |n| n}

    member_id { FactoryGirl.create(:project_node).osm_id }
    member_type 'N'
    member_role 'nothing in particular'
  end
end
