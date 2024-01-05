class_name SettingClasses
extends Control

const SeP_CLASS_CARD = preload("res://scene/SettingsPanel/SePClassCard.tscn");

@onready var buttonAdd: Button = $VBoxClassList/HBox/ButtonAdd;
@onready var vBoxClassList: VBoxContainer = $VBoxClassList;


func _ready() -> void:
	buttonAdd.pressed.connect(func(): add_class());

func add_class(class_data :SPClassData = null):
	var data :SPClassData = class_data if class_data != null else SPClassData.new();
	print("add class: data: ", data);
	SettingsPanel.config.class_data_dic[data.uuid] = data;
	var class_card :SePClassCard = SeP_CLASS_CARD.instantiate() as SePClassCard;
	class_card.copy_pressed.connect(copy_class.bind(class_card));
	class_card.delete_pressed.connect(delete_class.bind(class_card));
	class_card.size_flags_horizontal = Control.SIZE_FILL;
	vBoxClassList.add_child(class_card);
	class_card.data = data;

func copy_class(class_card :SePClassCard) -> void:
	print("copy class: ", class_card.data);
	var new_data := class_card.data.duplicate() as SPClassData;
	new_data.uuid = UUID.v4();
	add_class(new_data);

func delete_class(class_card :SePClassCard):
	print("delete class: ", class_card.data)
	class_card.queue_free();
	SettingsPanel.config.class_data_dic.erase(class_card.data.uuid);
