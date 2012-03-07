require "spec_helper"

describe "Map Requests" do
  context "with no data" do
    let!(:project) { FactoryGirl.create(:project) }

    it "should give you an empty map response" do
      visit project_api_map_path(project, :bbox => "1,2,1.1,2.1")
      page.source.should eql("<osm version='0.6' generator='Snapshot server'></osm>")
    end
  end

  context "with map data" do
    let!(:project) { FactoryGirl.create(:project) }
    let!(:way) { FactoryGirl.create(:project_way_with_nodes, :project_id => project.id) }

    it "should give you a map xml response" do

      bbox = RGeo::Cartesian::BoundingBox.new(way.nodes.first.geom.factory)
      bbox.add(way.nodes.first.geom.buffer(0.1))
      bbox_s = "#{bbox.min_x},#{bbox.min_y},#{bbox.max_x},#{bbox.max_y}"

      visit project_api_map_path(project, :bbox => bbox_s)
      
      page.source.should_not eql("<osm version='0.6' generator='Snapshot server'></osm>")
      page.source.should include("<way id=\"#{way.osm_id}\"")
      page.source.should include("<node id=\"#{way.nodes.first.osm_id}\"")
    end
  end
end