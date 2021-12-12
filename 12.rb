graph = {}

ARGF.each_line do |line|
  a, b = line.chomp.split('-')
  graph[a] ||= []
  graph[a] << b unless b == 'start'
  graph[b] ||= []
  graph[b] << a unless a == 'start'
end

puts graph.inspect

def terrible?(path)
  #puts path.inspect
  small_caves = path[1..].select { |cave| cave =~ /\A[a-z]+\z/ }
  visited_counts = {}
  small_caves.each do |cave|
    visited_counts[cave] ||= 0
    visited_counts[cave] += 1
    return true if visited_counts[cave] > 2
  end
  visited_counts.values.count { |c| c > 1 } > 1
end

def find_paths(graph, from_node = 'start', visited_nodes = ['start'])
  paths = []
  graph[from_node].each do |conn|
    path = visited_nodes + [conn]
    if conn == 'end'
      paths << path
    elsif !terrible?(path)
      paths.concat find_paths(graph, conn, path)
    end
  end
  paths
end

paths = find_paths(graph)
#pp paths
puts paths.size
