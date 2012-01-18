require 'spec_helper'

describe ProjectWay do
  describe "xml interface" do
    subject { FactoryGirl.create(:project_way_with_nodes) }

    it "should output the attributes" do
      subject.to_xml.to_s.should include(' id="2"')
      subject.to_xml.to_s.should include(' version="4"')
    end

    it "should list the nodes" do
      subject.nodes.count.should eql(10)
      subject.nodes.each do |node|
        subject.to_xml.to_s.should include("<nd ref=\"#{node.osm_id}\"/>")
      end
    end
  end
end
