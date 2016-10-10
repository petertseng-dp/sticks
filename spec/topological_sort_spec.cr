require "spec"
require "../src/topological_sort"

def all_u32(h : Hash(Int32, Array(Int32))) : Hash(UInt32, Array(UInt32))
  h.map { |h, k| {h.to_u32, k.map(&.to_u32)} }.to_h
end

describe "topological sort" do
  it "handles single path" do
    # sample1 should result in this
    paths_from(all_u32({
      1 => [] of Int32,
      2 => [1],
      3 => [1, 2, 4],
      4 => [1, 2],
    })).should eq([[1, 2, 4, 3]])
  end

  it "handles multiple branches at end" do
    # sample2 should result in this
    paths_from(all_u32({
      1 => [3],
      2 => [3, 5],
      3 => [4, 5],
      4 => [5],
      5 => [] of Int32,
    })).should eq([[5, 4, 3, 1, 2], [5, 4, 3, 2, 1]])
  end

  it "handles multiple branches at start" do
    # sample4 should result in this
    paths_from(all_u32({
      1 => [] of Int32,
      2 => [1, 4, 5],
      3 => [2, 4],
      4 => [] of Int32,
      5 => [4],
    })).should eq([[1, 4, 5, 2, 3], [4, 1, 5, 2, 3], [4, 5, 1, 2, 3]])
  end
end
