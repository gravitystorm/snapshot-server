# == Schema Information
#
# Table name: project_ways
#
#  id           :integer         not null, primary key
#  project_id   :integer         not null
#  osm_id       :integer(8)
#  version      :integer         not null
#  user_id      :integer         not null
#  tstamp       :datetime        not null
#  changeset_id :integer(8)      not null
#  tags         :hstore
#  status       :text
#

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

  describe "way nodes" do
    it "should not mix up nodes between projects" do
      way1 = FactoryGirl.create(:project_way_with_nodes, :osm_id => 1234, :project_id => 1 )
      way2 = FactoryGirl.create(:project_way_with_nodes, :osm_id => 1234, :project_id => 2 )

      way1.nodes.length.should eql(10)
    end
  end
end
