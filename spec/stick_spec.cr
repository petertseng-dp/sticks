require "spec"
require "../src/stick"

describe Stick do
  it "blocks at first endpoint" do
    # sample 1 sticks 2 and 1
    s2 = Stick.new(2_u32, 2.0, 3.0, 8.0, 1.0)
    s1 = Stick.new(1_u32, 0.0, 3.0, 4.0, 5.0)
    s2.blocked_by?(s1).should be_true
  end

  it "blocks at second endpoint" do
    # sample 1 sticks 2 and 1 (reversed)
    s2 = Stick.new(2_u32, 2.0, 3.0, 8.0, 1.0)
    s1 = Stick.new(1_u32, 4.0, 5.0, 0.0, 3.0)
    s2.blocked_by?(s1).should be_true
  end

  it "blocks in between" do
    # sample 2 sticks 4 and 5
    s4 = Stick.new(4_u32, 10.0, 5.0, 10.0, 10.0)
    s5 = Stick.new(5_u32, 9.0, 11.0, 18.0, 12.0)
    s4.blocked_by?(s5).should be_true
  end
end
