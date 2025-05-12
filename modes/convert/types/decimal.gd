extends Node

var type:String = "decimal"

func check_answer(new_text:String, correct_value:int) -> String:
	new_text=new_text.dedent()
	if not new_text.replace(" ", "").is_valid_int():
		return "Not a int."
	if new_text.to_int() == correct_value:
		return "Correct answer({2}): {0} == {1}".format([new_text, correct_value, correct_value])
	else:
		return "Wrong answer({2}): {0} == {1}".format([new_text, correct_value, correct_value])

func convert_value(value:int) -> String:
	return "{0}".format([value])
