class_name SettingsPanel
extends Panel

var config :SPConfig;

@onready var buttonShow: Button = $VBox/HBox/ButtonShow
@onready var buttonReload: Button = $VBox/HBox/ButtonReload
@onready var buttonSave: Button = $VBox/HBox/ButtonSave

# TODO 分设置选项在不同的类设定而不是在一个脚本里囊括所有的物件
const SeP_CLASS_CARD = preload("res://scene/SettingsPanel/SePClassCard.tscn");

@onready var buttonAdd: Button = $VBox/HSplit/ScrollClasses/VBox/HBox/ButtonAdd;
@onready var vBoxClassList: VBoxContainer = $VBox/HSplit/ScrollClasses/VBox;

func _ready() -> void:
	
	load_config();
	
	buttonSave.pressed.connect(save_config);
	
	buttonAdd.pressed.connect(func(): add_class());

func save_config():
	var err := ResourceSaver.save(config, "user://config.tres");
	print("config save result: ", error_string(err));

func load_config():
	var config_path := "user://config.tres";
	if FileAccess.file_exists(config_path):
		var _config :SPConfig = load(config_path);
		if _config != null:
			config = _config;
			print("load config: ", config);
	if config == null:
		config = SPConfig.new();
		print("init config: ", config);
		save_config();
	# load data
	for data in config.class_data_dic.values():
		add_class(data);

func add_class(class_data :SPClassData = null):
	var data :SPClassData = class_data if class_data != null else SPClassData.new();
	print("add class: data: ", data);
	config.class_data_dic[data.uuid] = data;
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
	config.class_data_dic.erase(class_card.data.uuid);
