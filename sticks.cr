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

# `Hash(UInt32, Array(UInt32)).new { |h, k| h[k] = [] of UInt32 }` is a possibility,
# but we have to be careful because each stick must have an entry!
# Otherwise, the sticks with [] blockers will not be in the hash,
# and `paths_from` won't be able to make the paths!
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
