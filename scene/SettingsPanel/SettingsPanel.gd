class_name SettingsPanel
extends Panel

static var config :SPConfig;

@onready var buttonShow: Button = $VBox/HBox/ButtonShow;
@onready var buttonReload: Button = $VBox/HBox/ButtonReload;
@onready var buttonSave: Button = $VBox/HBox/ButtonSave;

const buttonGroup: ButtonGroup = preload("res://scene/SettingsPanel/SettingsPanelListButtonGrouop.tres");
@onready var buttonClasses: Button = $VBox/HSplit/ScrollCat/VBox/ButtonClasses;
@onready var buttonSchedule: Button = $VBox/HSplit/ScrollCat/VBox/ButtonSchedule;

@onready var settingContainer: Control = $VBox/HSplit/Scroll/Container;
@onready var settingClasses: SettingClasses = $VBox/HSplit/Scroll/Container/Classes;
@onready var settingSchedule: SettingSchedule = $VBox/HSplit/Scroll/Container/Schedule;


func _ready() -> void:
	
	load_config();
	
	buttonSave.pressed.connect(save_config);
	
	buttonGroup.pressed.connect(switchSettingSection);

## Switch different setting section baesd on button group
func switchSettingSection(button: BaseButton):
	var index := button.get_index();
	var show_node :Control = null;
	for node in settingContainer.get_children():
		if !(node is Control): continue;
		if node.get_index() == index:
			show_node = node;
		else:
			node.visible = false;
	show_node.visible = true;

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
	# verify and fix the data
	for uuid in config.class_data_dic.keys():
		if config.class_data_dic_order.find(uuid) == -1:
			config.class_data_dic_order.append(uuid);
	save_config();
	# load data
	for data in config.get_classes_ordered():
		settingClasses.add_class(data);

