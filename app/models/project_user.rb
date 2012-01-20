# == Schema Information
#
# Table name: project_users
#
#  id         :integer         not null, primary key
#  project_id :integer         not null
#  osm_id     :integer         not null
#  name       :text            not null
#

class ProjectUser < ActiveRecord::Base
  belongs_to :project

  validates :project_id, :presence => true
  validates :osm_id, :presence => true
  validates :name, :presence => true

  def update_from(user)
    self.osm_id = user.id
    self.name = user.name
  end
end