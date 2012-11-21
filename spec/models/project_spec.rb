# == Schema Information
#
# Table name: projects
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  loaded     :boolean         default(FALSE), not null
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Project do
  describe "newly created" do
    subject { FactoryGirl.create(:project) }

    it "should not be loaded" do
      subject.loaded.should be_false
    end

    it "must have a unique title" do
      subject.should validate_uniqueness_of(:title)
    end
  end

  describe "to be valid" do
    subject { FactoryGirl.build(:project) }

    it "must have a title" do
      subject.title = nil
      subject.should_not be_valid
    end
  end

  describe "transfer" do
    let(:way) { FactoryGirl.create(:way_with_nodes) }
    let(:relation) { FactoryGirl.create(:relation_with_members) }
    let(:project) { FactoryGirl.create(:project) }

    it "should work for ways" do
      way.should be_valid
      project.ways.should be_empty
      project.transfer

      project.ways.should_not be_empty
      project.ways.first.nodes.length.should eq(way.nodes.length)
    end

    it "should work for relations" do
      relation.should be_valid
      relation.relation_members.length.should_not be_zero
      project.relations.should be_empty
      project.transfer

      project.relations.should_not be_empty
      project.relations.first.relation_members.length.should_not be_zero
    end
  end
end
