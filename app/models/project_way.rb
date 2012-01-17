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

class ProjectWay < ActiveRecord::Base
  include Entity

  belongs_to :project

  validates :osm_id, :presence => true
  validates :version, :presence => true
  validates :user_id, :presence => true
  validates :tstamp, :presence => true
  validates :changeset_id, :presence => true

  def self.default_status
    WAY_STATUS_DEFAULT
  end

  def update_from(way)
    self.osm_id = way.id
    self.version = way.version
    self.user_id = way.user_id
    self.tstamp = way.tstamp
    self.changeset_id = way.changeset_id
    self.tags = way.tags
  end
end
