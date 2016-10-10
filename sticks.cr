require "../src/stick"
require "../src/topological_sort"

if ARGV.empty?
  puts "usage: #{PROGRAM_NAME} input"
  exit(1)
end

raw_lines = File.read_lines(ARGV[0])

sticks = raw_lines[1..-1].each_with_object({} of UInt32 => Stick) { |l, h|
  raw_id, raw_vals = l.split(':')
  vals = raw_vals.split(',').map(&.to_f)
  id = raw_id.to_u32
  h[id] = Stick.new(id, vals[0], vals[1], vals[2], vals[3])
}

# !!! Hash(UInt32, Array(UInt32)) { |h, k| [] of UInt32 } *would* work.
# However, then the `covers[id2] << id1` line below would need to change to explicitly assign into covers.
# Otherwise, a temporary array is created, modified, then thrown away without being put into the hash.
covers = {} of UInt32 => Array(UInt32)

sticks.each { |id1, stick1|
  covers[id1] = [] of UInt32
  sticks.each { |id2, stick2|
    next if id2 == id1
    covers[id1] << id2 if stick1.blocked_by?(stick2)
  }
}

puts covers
puts paths_from(covers)
