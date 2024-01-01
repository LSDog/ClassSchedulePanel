class_name Util;
extends Object

static func is_am(unix_time :int) -> bool:
	return Time.get_datetime_dict_from_unix_time(unix_time).get("hour", 0) < 12;

## returns 12 hours time dic, see Time.get_datetime_dict_from_unix_time().
## dic also contains a value "am":true|false
static func get_12h_datetime_dict(unix_time :int) -> Dictionary:
	var dic := Time.get_datetime_dict_from_unix_time(unix_time);
	var hour :int = dic.get("hour", 0);
	if 0 <= hour && hour < 12:
		dic["am"] = true;
	else:
		hour -= 12;
		dic["am"] = false;
	dic["hour"] = hour;
	return dic;

## return time in 12 hours time like "p.m. 1:15"
static func get_datetime_hour_minute(unix_time :int, has_ampm :bool = true) -> String:
	var time_dic := get_12h_datetime_dict(unix_time);
	var hour :int = time_dic.get("hour", 0);
	var minute :int = time_dic.get("minute", 0);
	print(minute)
	if has_ampm:
		var ampm :String = "a.m." if (time_dic.get("am", true)) else "p.m.";
		return "%s %d:%s" % [ampm, hour, "%02d" % minute];
	else:
		return "%d:%s" % [hour, "%02d" % minute];
		
