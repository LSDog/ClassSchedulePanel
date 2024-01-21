class_name SettingClasses
extends Control

const SeP_CLASS_CARD = preload("res://scene/SettingsPanel/SePClassEditCard.tscn");

@onready var buttonAdd: Button = $HBox/ButtonAdd;
@onready var vBoxClassList: VBoxContainer = $VBoxClassList;

var dragging :bool = false;
var dragging_card :SePClassEditCard;
var dragging_prev_index :int = -1;
var dragging_after_index :int = -1;

func _ready() -> void:
	buttonAdd.pressed.connect(func(): add_class());

func _process(_delta: float) -> void:
	# Dragging function
	if dragging:
		get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if !dragging: return;
	if event is InputEventMouseMotion:
		var pos :Vector2 = event.position - vBoxClassList.global_position;
		var index = dragging_card.get_index()
		for card in vBoxClassList.get_children():
			var dest_index := card.get_index();
			if (dest_index != index &&
			pos.y > card.position.y &&
			pos.y < card.position.y + card.size.y):
				vBoxClassList.move_child(dragging_card, dest_index);
				dragging_after_index = dest_index;
				break;

func add_class(class_data :SPClassData = null):
	var data :SPClassData = class_data if class_data != null else SPClassData.new();
	#print("add class: data: ", data);
	if class_data == null: SettingsPanel.config.add_class_data(data);
	var class_card :SePClassEditCard = SeP_CLASS_CARD.instantiate() as SePClassEditCard;
	class_card.copy_pressed.connect(copy_class.bind(class_card));
	class_card.delete_pressed.connect(delete_class.bind(class_card));
	class_card.size_flags_horizontal = Control.SIZE_FILL;
	vBoxClassList.add_child(class_card);
	class_card.data = data;
	class_card.drag.connect(drag_class_card.bind(class_card));
	class_card.drop.connect(drop_class_card.bind(class_card));

@warning_ignore("static_called_on_instance")
func copy_class(class_card :SePClassEditCard) -> void:
	print("copy class: ", class_card.data);
	var new_data := class_card.data.duplicate() as SPClassData;
	new_data.uuid = UUID.v4();
	add_class(new_data);

func delete_class(class_card :SePClassEditCard):
	print("delete class: ", class_card.data)
	class_card.queue_free();
	SettingsPanel.config.remove_class_data(class_card.data.uuid);

func drag_class_card(class_card :SePClassEditCard):
	print("drag_class_card: ", class_card.data.name);
	dragging = true;
	dragging_card = class_card;
	dragging_prev_index = class_card.get_index();
	dragging_after_index = dragging_prev_index;
	#region Animation
	var tween := create_tween();
	tween.tween_property(class_card, "modulate:a", 0.0, 0.2);
	#endregion

func drop_class_card(class_card: SePClassEditCard):
	print("drop_class_card: ", class_card.data.name);
	dragging = false;
	# exchange class data index
	if dragging_prev_index != dragging_after_index:
		SettingsPanel.config.change_class_order(
			class_card.data.uuid, dragging_after_index);
		print("changed class '%s' index %d -> %d" % [
			class_card.data.name, dragging_prev_index, dragging_after_index]);
		
	#region Animation
	var tween := create_tween();
	tween.tween_property(class_card, "modulate:a", 1.0, 0.2);
	#endregion
