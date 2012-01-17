require "spec_helper"

describe "Projects" do
  context "index" do
    let!(:project) { FactoryGirl.create(:project) }

    it "should show you a list of projects" do
      visit projects_path
      page.should have_link(project.title)
    end
  end

  context "new" do
    before do
      visit projects_path
    end

    it "should have a link to create a new project" do
      page.should have_link("New Project")
    end

    it "should let you create a new project" do
      visit projects_path
      click_on "New Project"
      fill_in :title, :with => "My First Project"
      click_on "Create Project"
      page.should have_content("My First Project")
    end
  end

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
