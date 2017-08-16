require './schema_generator'

sg = SchemaGenerator.new('./example.schema.txt')

h = {}

sg.split_into_nodes.combination(2).to_a.each do |node_a, node_b|
  link = Link.new(node_a, node_b)
  h["#{node_a.name}_#{node_b.name}"] = link.link?
end

File.open('test.dot', 'w+') do |writeable|
  writeable.write("digraph g {\n")
  writeable.write("node [shape=record,color=Red,fontname=Courier];\n")
  writeable.write("edge [color=Blue]\n")
  sg.split_into_nodes.each do |node|
    writeable.write node.to_struct
  end
  h.select {|k,v|v == true}.each do |k,v| 
    writeable.write "#{k.split('_')[0]} -> #{k.split('_')[1]} [dir=\"none\"]\n"
  end
  writeable.write("}\n")
end