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
end
