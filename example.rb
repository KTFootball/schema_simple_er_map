require './schema_generator'

sg = SchemaGenerator.new('./example.schema.txt', 'test.dot')
sg.split_into_nodes
sg.draw