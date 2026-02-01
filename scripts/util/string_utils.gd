class_name StringUtils


static func is_set(string: String) -> bool:
	return string != null and not string.is_empty()


static func is_empty(string: String) -> bool:
	return string == null or string.is_empty()


static func join(char_array: Array[String]) -> String:
	var output: String = ""
	for c: String in char_array:
		output += c
	return output


## Adds suffix and prefix as padding to given text.
static func add_padding(text: String, n: int, padding: String = " ") -> String:
	for i: int in range(n):
		text = padding + text + padding
	return text


## Shorten text from end to fit given max_length.
static func trim_end(text: String, max_length: int) -> String:
	return text.substr(0, min(text.length(), max_length))


## Remove chars from text that are not in allowed charset.
static func trim_unallowed(text: String, allowed_charset: String) -> String:
	var output: String = ""
	for c in text:
		if allowed_charset.contains(c):
			output += c
	return output




static func sanitize_newline(text: String) -> String:
	text = text.replace("\n", "")
	text = text.replace("\r\n", "")
	text = text.replace("\n\r", "")
	return text


static func charset_map(charset_keys: String, charset_values: String) -> Dictionary:
	var map: Dictionary = {}
	for i: int in range(charset_keys.length()):
		map[charset_keys[i]] = charset_values[i]
	return map
