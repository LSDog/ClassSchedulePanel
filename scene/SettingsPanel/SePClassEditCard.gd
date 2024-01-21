class_name SePClassEditCard
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

@onready var labelDrag: Label = $HBox/VBoxButton/LabelDrag;

var dragged :bool = false;

signal copy_pressed;
signal delete_pressed;
signal drag;
signal drop;

func _ready() -> void:
	buttonCopy.pressed.connect(func():copy_pressed.emit());
	buttonDelete.pressed.connect(func():delete_pressed.emit());
	bind_text_change(editClassName, "name");
	bind_text_change(editShortName, "short_name");
	bind_text_change(editTeacher, "teacher");
	bind_text_change(editPlace, "place");
	spinDuration.value_changed.connect(func(value:float):data.duration=floori(value));
	colorPicker.color_changed.connect(func(color:Color):data.color=color);

func _notification(what: int) -> void:
	if dragged && what == NOTIFICATION_DRAG_END:
		dragged = false;
		drop.emit();

func _get_drag_data(at_position: Vector2) -> Variant:
	if !labelDrag.get_global_rect().has_point(get_global_mouse_position()): return;
	var preview := Control.new();
	var child := duplicate(0);
	preview.add_child(child);
	preview.size = size;
	child.size = size;
	child.position = -at_position;
	set_drag_preview(preview);
	dragged = true;
	drag.emit();
	return self;

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
