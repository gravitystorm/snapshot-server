# == Schema Information
#
# Table name: projects
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  loaded     :boolean         default(FALSE), not null
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :project do
    title "My first project"
  end
end
