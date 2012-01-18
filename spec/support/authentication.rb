shared_context "signs in" do
  before do
    visit new_admin_session_path
    fill_in "Email", with: current_user.email
    fill_in "Password", with: password
    click_button "Sign in"
    page.should have_content("Signed in")
  end
end

shared_context "signed in as an admin", as: :admin do
  include_context "signs in"

  let!(:current_user) { FactoryGirl.create(:stewie) }
  let!(:password) { FactoryGirl.attributes_for(:stewie)[:password] }
end
