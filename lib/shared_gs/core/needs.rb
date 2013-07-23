def needs(path)
  if path.index('./') == 0
    origin = caller.first.split(':').first
    path = origin.sub(/\/[^\/]+$/, path[1..-1])
    require(path)
  elsif path.index('*') != nil
    require_all(path)
  else
    require(path)
  end
end
