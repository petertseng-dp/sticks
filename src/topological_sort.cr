def paths_from(covers : Hash(UInt32, Array(UInt32))) : Array(Array(UInt32))
  return [[] of UInt32] if covers.empty?
  uncovered = covers.select { |k, v| v.empty? }.keys
  uncovered.flat_map { |first|
    new_covers = covers.compact_map { |k, v| {k, v - [first]} unless k == first }.to_h
    paths_from(new_covers).map { |path| [first] + path }
  }
end
