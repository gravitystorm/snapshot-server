require "spec_helper"

describe "Project Ways" do
  context "as a normal user" do
    include Rack::Test::Methods

    let!(:project) { FactoryGirl.create(:project) }
    let!(:way) { FactoryGirl.create(:project_way, :project_id => project.id) }

    it "should show you the way" do
      visit project_api_way_path(project, way.osm_id)
      page.source.should eql(way.to_xml.to_s)
    end

    it "should let you set the status" do
      post status_project_api_way_path(project, way.osm_id), "bar"
      last_response.body.should eql("bar")
      way.reload
      way.status.should eql("bar")
    end
  end
end
