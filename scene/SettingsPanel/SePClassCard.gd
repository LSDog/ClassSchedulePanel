class_name SePClassCard
extends PanelContainer

@export var data :SPClassData:
	set(value):
		data = value;
		load_data();

@onready var editClassName: LineEdit = $HBox/VBoxName/HBoxClassName/LineEdit;
@onready var editShortName: LineEdit = $HBox/VBoxName/HBoxShortName/LineEdit;
@onready var colorPicker: ColorPickerButton = $HBox/VBoxName/VBoxColor/ColorPickerButton;
@onready var spinDuration: SpinBox = $HBox/VBoxInfo/HBoxShortDuration/SpinBox;
@onready var editTeacher: LineEdit = $HBox/VBoxInfo/HBoxShortTeacher/LineEdit;
@onready var editPlace: LineEdit = $HBox/VBoxInfo/HBoxShortPlace/LineEdit;

@onready var buttonCopy: Button = $HBox/VBoxButton/ButtonCopy;
@onready var buttonDelete: Button = $HBox/VBoxButton/ButtonDelete;

signal copy_pressed;
signal delete_pressed;

func _ready() -> void:
	buttonCopy.pressed.connect(func():copy_pressed.emit());
	buttonDelete.pressed.connect(func():delete_pressed.emit());
	bind_text_change(editClassName, "name");
	bind_text_change(editShortName, "short_name");
	bind_text_change(editTeacher, "teacher");
	bind_text_change(editPlace, "place");
	spinDuration.value_changed.connect(func(value:float):data.duration=floori(value));
	colorPicker.color_changed.connect(func(color:Color):data.color=color);

func bind_text_change(lineEdit :LineEdit, prop_name :String):
	lineEdit.text_changed.connect(func(text:String): data.set(prop_name, text));

func load_data():
	assert(data != null, "class data is null!");
	editClassName.text = data.name;
	editShortName.text = data.short_name;
	editTeacher.text = data.teacher;
	editPlace.text = data.place;
	spinDuration.value = data.duration;
	colorPicker.color = data.color;
