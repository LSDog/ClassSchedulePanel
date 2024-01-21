class_name SPDayScheduleData
extends Resource
## The Data of a signle day's schedule
##
## Stores the classes and times in a single day

## Start times of each class
## If there's no enough data, the start time will be previous class's end time
@export var start_time_array :Array[int] = [0];

## Classes in this day, use UUID to represent the class
@export var class_array :Array[String] = [];
