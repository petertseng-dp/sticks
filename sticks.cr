class Stick
  @slope : Float64?
  @xrange : Range(Float64, Float64)

  getter :id, :x1, :y1, :x2, :y2, :xrange

  def initialize(@id : UInt32, @x1 : Float64, @y1 : Float64, @x2 : Float64, @y2 : Float64)
    @xrange = {@x1, @x2}.min..{@x1, @x2}.max
    @slope = @x2 == @x1 ? nil : (@y2 - @y1) / (@x2 - @x1)
  end

  def y_at(x : Float64) : Float64
    # !!! Can't just use @slope, since @slope could change...?
    if (slope = @slope)
      @y1 + slope * (x - @x1)
    else
      {@y1, @y2}.max
    end
  end

  def endpoints : Tuple(Tuple(Float64, Float64), Tuple(Float64, Float64))
    { {@x1, @y1}, {@x2, @y2} }
  end

  def blocked_by?(that : Stick) : Bool
    that.endpoints.any? { |p| blocked_by?(*p) } || endpoints.all? { |p|
      # all? vs any? only matters if lines can intersect,
      # but in that case this problem doesn't have defined behavior.
      x, y = p
      that.xrange.includes?(x) && that.y_at(x) > y
    }
  end

  def blocked_by?(x : Float64, y : Float64) : Bool
    @xrange.includes?(x) && y_at(x) < y
  end
end

if ARGV.empty?
  puts "usage: #{PROGRAM_NAME} input"
  exit(1)
end

def paths_from(covers : Hash(UInt32, Array(UInt32))) : Array(Array(UInt32))
  return [[] of UInt32] if covers.empty?
  uncovered = covers.select { |k, v| v.empty? }.keys
  uncovered.flat_map { |first|
    # !!! Can't use covers.map.to_h since the types become Hash(K|V, K|V)
    new_covers = covers.each_with_object({} of UInt32 => Array(UInt32)) { |(k, v), h| h[k] = v - [first] unless k == first }
    paths_from(new_covers).map { |path| [first] + path }
  }
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
