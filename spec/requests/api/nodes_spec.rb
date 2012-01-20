require "spec_helper"

describe "Project Nodes" do
  context "as a normal user" do
    include Rack::Test::Methods

    let!(:project) { FactoryGirl.create(:project) }
    let!(:node) { FactoryGirl.create(:project_node, :project_id => project.id) }

    it "should show you the node" do
      visit project_api_node_path(project, node.osm_id)
      page.source.should eql(node.to_xml.to_s)
    end

    it "should let you set the status" do
      post status_project_api_node_path(project, node.osm_id), "foo"
      last_response.body.should eql("foo")
      node.reload
      node.status.should eql("foo")
    end
  end
end