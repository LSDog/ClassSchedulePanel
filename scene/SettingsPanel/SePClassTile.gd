class_name SePClassTile
extends Panel

@onready var label :Label = $Label;
@onready var style_box :StyleBoxFlat = get_theme_stylebox("panel");

var class_uuid :String; # the uuid of the class

func set_label(text: String):
	# set text
	label.text = text;
	# resize label
	label.reset_size();
	label.pivot_offset = label.size/2.0;
	if label.size.x > size.x:
		var factor = size.x/label.size.x;
		label.scale *= factor;
	else:
		label.scale = Vector2.ONE;
	label.offset_left = 0;
	label.offset_right = 0;

func set_color(color: Color):
	style_box.bg_color = color;
