class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end

class SchemaGenerator
  def initialize(filename)
    @filename = filename
    @nodes = []
  end

  def split_into_nodes
    original = File.open(@filename, 'r') { |file| file.readlines }
    blankless = original.reject{ |line| line.match(/^$/) }

    @nodes = blankless.join().split("--------------------------------------------------").map do |b|
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