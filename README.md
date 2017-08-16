# schema_simple_er_map

## Requirements

You should have [Graphviz](http://www.graphviz.org/) installed on your machine.

## Example

Consider you have a file called `example.schema.txt`

```txt
Club
==================================================
id                                         int(11)
name                                  varchar(255)
address                               varchar(255)
expired_at                                datetime
created_at                                datetime
updated_at                                datetime
ecard                                      int(11)
image_keys                            varchar(255)
portable                                tinyint(1)
--------------------------------------------------

School
==================================================
id                                         int(11)
name                                  varchar(255)
address                               varchar(255)
ecard                                      int(11)
expired_at                                datetime
created_at                                datetime
updated_at                                datetime
portable                                tinyint(1)
--------------------------------------------------

Game
==================================================
id                                         int(11)
start_at                                  datetime
end_at                                    datetime
lat                                         double
lng                                         double
address                               varchar(255)
created_at                                datetime
updated_at                                datetime
name                                  varchar(255)
image_key                             varchar(255)
image_keys                            varchar(255)
--------------------------------------------------

ClubGame
==================================================
game_id                                    int(11)
club_id                                    int(11)
--------------------------------------------------

SchoolGame
==================================================
game_id                                    int(11)
school_id                                  int(11)
--------------------------------------------------

ClubProfile
==================================================
id                                         int(11)
user_id                                    int(11)
club_id                                    int(11)
avatar_key                            varchar(255)
course_id                                  int(11)
gender                                     int(11)
birthday                                  datetime
point                                      int(11)
ce                                         int(11)
created_at                                datetime
updated_at                                datetime
realname                              varchar(255)
--------------------------------------------------

SchoolProfile
==================================================
id                                         int(11)
user_id                                    int(11)
avatar_key                            varchar(255)
classroom_id                               int(11)
gender                                     int(11)
birthday                                  datetime
point                                      int(11)
ce                                         int(11)
created_at                                datetime
updated_at                                datetime
realname                              varchar(255)
school_id                                  int(11)
--------------------------------------------------
```

Then you can write a ruby file like below

```ruby
require './schema_generator'

sg = SchemaGenerator.new('./example.schema.txt', 'test.dot')
sg.split_into_nodes
sg.draw
```

You will get a dot file and a png file.

![test.dot.png](https://github.com/KTFootball/schema_simple_er_map/blob/master/test.dot.png "test.dot.png")