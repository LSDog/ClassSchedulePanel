class_name SPClassData
extends Resource
## The Data of a Class
##
## Stores the basic data of a single class

@export var uuid :String = UUID.v4();

@export var name :String = ""; ## class name
@export var short_name :String = ""; ## short version of a class name
@export var teacher :String = ""; ## class teacher
@export var place :String = ""; ## class room or place to take class
@export var duration :int = 40; ## totoal [minute] of the class
@export var color :Color = Color.WHITE_SMOKE; ## representative color


func _to_string() -> String:
	return "SePClassCard %s:
		{name: %s, short_name: %s, teacher: %s, place: %s, duration: %d, color: %s}
		" % [uuid, name, short_name, teacher, place, duration, color.to_html()];
