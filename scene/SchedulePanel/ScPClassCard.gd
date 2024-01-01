class_name ScPClassCard
extends PanelContainer
## A class card in the list panel

@export var data: SPClassData; ## This class' data
@export var override: bool = false; ## If this specific class has changes
@export var override_data: SPClassData; ## overrided data

@export var start_time: float; ## The start time of this class

@onready var colorRect: ColorRect = $HBox/ColorRect;
@onready var labelShortName: Label = $HBox/VBox/LabelShortName;
@onready var labelInfo: Label = $HBox/VBox/LabelInfo;
@onready var labelTime: Label = $HBox/VBox/LabelTime;


func _ready() -> void:
	start_time = floorf(Time.get_unix_time_from_system());
	load_info();


func load_info() -> void:
	var data := self.override_data if override else self.data;
	labelShortName.text = data.short_name;
	labelInfo.text = labelInfo.text.format({"name": data.name, "teacher": data.teacher, "duration": data.duration});
	var start_time_str : String = Util.get_datetime_hour_minute(start_time);
	var end_time_str : String = Util.get_datetime_hour_minute(start_time+data.duration*60, false);
	labelTime.text = start_time_str + " - " + end_time_str;
	colorRect.color = data.color;
