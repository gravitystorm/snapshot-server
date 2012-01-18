require 'spec_helper'

describe ProjectRelation do
  describe "xml interface" do
    subject { FactoryGirl.create(:project_relation) }

    it "should output the attributes" do
      subject.to_xml.to_s.should include(' id="2"')
      subject.to_xml.to_s.should include(' version="4"')
    end
  end
end
