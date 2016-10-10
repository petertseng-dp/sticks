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
