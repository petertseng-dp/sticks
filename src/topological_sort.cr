def paths_from(covers : Hash(UInt32, Array(UInt32))) : Array(Array(UInt32))
  return [[] of UInt32] if covers.empty?
  uncovered = covers.select { |k, v| v.empty? }.keys
  uncovered.flat_map { |first|
    # !!! Can't use covers.map.to_h since the types become Hash(K|V, K|V)
    new_covers = covers.each_with_object({} of UInt32 => Array(UInt32)) { |(k, v), h| h[k] = v - [first] unless k == first }
    paths_from(new_covers).map { |path| [first] + path }
  }
end
