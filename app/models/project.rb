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

class Project < ActiveRecord::Base
  has_many :project_nodes
  has_many :project_relations
  has_many :project_relation_members
  has_many :project_way_nodes
  has_many :project_ways
  has_many :project_users

  # This might take a while...
  def transfer
    Node.all.each do |node|
      pn = self.project_nodes.new
      pn.update_from(node)
      pn.save!
    end

    # ...etc...
  end
end