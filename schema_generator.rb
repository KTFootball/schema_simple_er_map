class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end

class SchemaNode
  attr_accessor :name, :attrs
  def initialize(name, attrs)
    @name = name
    @attrs = attrs
  end

  def to_struct
    "#{@name} [label=\"#{@name}|{#{@attrs.map {|e| e.split(':')[0]}.join('|')}}\"];\n"
  end

  def display
    puts @name
    puts @attrs
  end
end

class Link
  def initialize(node_a, node_b)
    @node_a = node_a
    @node_b = node_b
  end

  def link?
    case_a = @node_b.attrs.include?("#{@node_a.name.underscore}_id:int(11)")
    case_b = @node_a.attrs.include?("#{@node_b.name.underscore}_id:int(11)")
    case_a || case_b
  end
end

class SchemaGenerator
  def initialize(source, target)
    @source, @target = source, target
    @nodes = []
    @h = {}
  end

  def split_into_nodes
    original = File.open(@source, 'r') { |file| file.readlines }
    blankless = original.reject{ |line| line.match(/^$/) }

    @nodes = blankless
      .join()
      .split("--------------------------------------------------").map do |b|
      sources = b.lines.reject{|line| line == "\n"}
      name = sources.first.gsub("\n",'')
      attrs = sources[2..-1].map { |e| e.split(' ')
      .join(':') }
      .reject{ |s| s.include? "created_at" }
      .reject{ |s| s.include? "updated_at"}
      .reject{ |s| s == "id:int(11)"}
      .concat ["#{name.underscore}_id:int(11)"]
      .uniq
      sn = SchemaNode.new(name, attrs)
    end
  end
  
  def draw
    File.open(@target, 'w+') do |writeable|
      writeable.write("digraph g {\n")
      writeable.write("node [shape=record,color=Red,fontname=Courier];\n")
      writeable.write("edge [color=Blue]\n")

      @nodes.each do |node|
        writeable.write node.to_struct
      end
      
      @nodes.combination(2).to_a.each do |node_a, node_b|
        link = Link.new(node_a, node_b)
        @h["#{node_a.name}_#{node_b.name}"] = link.link?
      end
      
      @h.select {|k,v|v == true}.each do |k,v|
        writeable.write "#{k.split('_')[0]} -> #{k.split('_')[1]} [dir=\"none\"]\n"
      end

      writeable.write("}\n")
    end
  end
end