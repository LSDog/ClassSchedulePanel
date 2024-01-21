class_name SettingSchedule
extends Control

const CLASS_TILE = preload("res://scene/SettingsPanel/SePClassTile.tscn");

@onready var vBoxTileList: VBoxContainer = $HSplit/BoxClassChoose/Scroll/VBox;

func _ready() -> void:
	_ready_later.call_deferred();
	visibility_changed.connect(func(): if visible: reload_tiles());

func _ready_later():
	load_tiles();

func reload_tiles():
	vBoxTileList.get_children().any(func(node:Node): node.free());
	load_tiles();

func load_tiles():
	print("load_tiles")
	for class_data in SettingsPanel.config.get_classes_ordered():
		add_class_tile(class_data);

func add_class_tile(class_data: SPClassData):
	var tile :SePClassTile = CLASS_TILE.instantiate() as SePClassTile;
	tile.class_uuid = class_data.uuid;
	vBoxTileList.add_child(tile);
	tile.set_label(class_data.get_short_name());
	tile.set_color(class_data.color);
	
