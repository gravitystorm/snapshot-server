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
#

require 'spec_helper'

describe ProjectNode do
  describe "newly created" do
    subject { FactoryGirl.create(:project_node) }

    it "should have an osm_id" do
      subject.osm_id.should eql(2)
    end
  end

  describe "to be valid" do
    subject { FactoryGirl.build(:project_node) }

    it "must belong to a project" do
      subject.project = nil
      subject.should_not be_valid
    end
  end
end
