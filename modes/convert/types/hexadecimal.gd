extends Node

var type:String = "hexadecimal"

func check_answer(new_text:String, correct_value:int) -> String:
	new_text=new_text.dedent()
	if not new_text.replace(" ", "").is_valid_hex_number():
		return "Not a hexadecimal."
	if new_text.hex_to_int() == correct_value:
		return "Correct answer({2}): {0} == {1}".format([new_text, convert_value(correct_value), correct_value])
	else:
		return "Wrong answer({2}): {0} == {1}".format([new_text, convert_value(correct_value), correct_value])

func convert_value(value:int) -> String:
	return String.num_int64(value, 16, true)
