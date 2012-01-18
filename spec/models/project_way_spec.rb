require 'spec_helper'

describe ProjectWay do
  describe "xml interface" do
    subject { FactoryGirl.create(:project_way) }

    it "should output the attributes" do
      subject.to_xml.to_s.should include(' id="2"')
      subject.to_xml.to_s.should include(' version="4"')
    end
  end
end
