# == Schema Information
#
# Table name: nodes
#
#  id           :integer          not null, primary key
#  version      :integer          not null
#  user_id      :integer          not null
#  tstamp       :datetime         not null
#  changeset_id :integer          not null
#  tags         :hstore
#  geom         :spatial({:srid=>
#

require 'spec_helper'

describe Node do
    describe "newly created" do
    subject { FactoryGirl.create(:node) }

    it "should have an osm_id" do
      subject.id.should be_an_integer
    end
  end
end
