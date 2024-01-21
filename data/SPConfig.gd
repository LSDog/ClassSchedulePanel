class_name SPConfig
extends Resource
## Config and class data

## Contains all the SPClassData, the key is a UUID string;
@export var class_data_dic :Dictionary = {};

## The order of class_data_dic, contains UUID
@export var class_data_dic_order :Array[String] = [];

## Contains 7 SPDayScheduleData, from Monday(0) to Sunday(6)
## Use UUID to represent a class
@export var class_schedule_array :Array[SPDayScheduleData] = [];

func add_class_data(data: SPClassData, index: int = -1):
	class_data_dic[data.uuid] = data;
	if index == -1:
		class_data_dic_order.append(data.uuid);
	else:
		index = maxi(index, class_data_dic_order.size());
		class_data_dic_order.insert(index, data);

func get_class_data_index(uuid: String) -> int:
	return class_data_dic_order.find(uuid);

func change_class_order(uuid: String, index: int):
	var prev_index := class_data_dic_order.find(uuid);
	if prev_index == -1 || prev_index == index: return;
	if index >= class_data_dic.size(): return;
	class_data_dic_order.remove_at(prev_index);
	class_data_dic_order.insert(index, uuid);

func remove_class_data_at(index: int):
	var uuid := class_data_dic_order[index];
	class_data_dic_order.remove_at(index);
	class_data_dic.erase(uuid);

func remove_class_data(uuid: String):
	remove_class_data_at(get_class_data_index(uuid));

func get_classes_ordered() -> Array[SPClassData]:
	var array :Array[SPClassData] = [];
	for uuid in class_data_dic_order:
		array.append(class_data_dic[uuid]);
	return array;
