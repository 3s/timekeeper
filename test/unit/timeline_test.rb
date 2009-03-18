require 'test_helper'

class TimelineTest < ActiveSupport::TestCase

  test "test state" do
    yesterday = Time.now - (3600*24)
    t = Timeline.new(:user_id => 1, :what => "boe", :customer_id => 1, :time_spend_at => yesterday)
    assert t.save!
    assert t.completed?
    t.start
    assert_equal t.state, "started"
    t.save
    t.reload
    assert_not_nil t.started_at
    t.started_at = yesterday
    t.stop
    t.save
    t.reload
    assert_not_nil t.time_spend
    puts t.time_spend

  end
end
