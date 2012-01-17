require "spec_helper"

describe "Projects" do

  context "edit" do
    let(:project) { FactoryGirl.create(:project) }

    before do
      visit project_path(project)
    end

    it "should show you an edit link" do
      page.should have_content("Edit project details")
    end

    it "should let you change the title" do
      click_on "Edit project details"
      fill_in :title, :with => "New Title"
      click_on "Update"
      page.should have_content "Project updated"
      page.should have_content "New Title"
    end
  end
end
