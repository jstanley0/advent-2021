graph = ARGF.lines.inject({}) do |h, line|
  a, b = line.chomp.split('-')
  h[a] ||= []
  h[a] << b unless b == 'start'
  h[b] ||= []
  h[b] << a unless a == 'start'
  h
end

def count_paths(graph, from_node = 'start', exclude_nodes = [], mulligan:)
  paths = 0
  graph[from_node].each do |conn|
    if conn == 'end'
      paths += 1
    else
      if conn.match? /\A[a-z]+\z/
        if exclude_nodes.include?(conn)
          paths += count_paths(graph, conn, exclude_nodes, mulligan: false) if mulligan
        else
          paths += count_paths(graph, conn, exclude_nodes + [conn], mulligan: mulligan)
        end
      else
        paths += count_paths(graph, conn, exclude_nodes, mulligan: mulligan)
      end
    end
  end
  paths
end

puts count_paths(graph, mulligan: true)
