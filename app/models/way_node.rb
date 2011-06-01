class WayNode < ActiveRecord::Base

  belongs_to :node

  belongs_to :way
end
