# == Schema Information
#
# Table name: project_relations
#
#  id           :integer         not null, primary key
#  project_id   :integer         not null
#  osm_id       :integer(8)      not null
#  version      :integer         not null
#  user_id      :integer         not null
#  tstamp       :datetime        not null
#  changeset_id :integer(8)      not null
#  tags         :hstore
#

class ProjectRelation < ActiveRecord::Base
  belongs_to :project

  validates :project_id, :presence => true
  validates :osm_id, :presence => true
  validates :version, :presence => true
  validates :user_id, :presence => true
  validates :tstamp, :presence => true
  validates :changeset_id, :presence => true
end
