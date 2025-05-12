extends Node

const type:String="binary"

func check_answer(new_text:String, correct_value:int) -> String:
	new_text=new_text.dedent()
	if not new_text.replace(" ", "").is_valid_int():
		return "Not a int."
	else:
		new_text=append_binary_leading_zeros(new_text.replace(" ", ""))
		var correct=get_binary(correct_value)
		if new_text == correct:
			return "Correct answer({2}): {0} == {1}".format([binary_insert_spaces(new_text), binary_insert_spaces(correct), correct_value])
		else:
			return "Wrong answer({2}): {0} != {1}".format([binary_insert_spaces(new_text), binary_insert_spaces(correct), correct_value])
	#ask_a_question()
	#$CC/VBC/answer.clear()

#Wrapper to get value as this type.
func convert_value(value:int) -> String:
	return binary_insert_spaces(get_binary(value))

func append_binary_leading_zeros(binary:String) -> String:
	var c:int=4-(binary.length()%4)
	if c==4: return binary
	for i:int in range(c):
		binary="0{old}".format({"old":binary})
	return binary

func binary_insert_spaces(binary:String) -> String:
	if binary.length() <= 4: return binary
	var return_binary:String=""
	for i in range(binary.length()/4):
		return_binary="{old}{binary} ".format({"binary":binary.substr(i*4, 4), "old":return_binary})
	return return_binary

func get_binary(value:int) -> String:
	var binary:String
	var n:int=value
	while n > 1:
		var mod=n%2
		binary="{old}{new}".format({"old":binary, "new":mod})
		n=n/2
	binary="{old}{new}".format({"old":binary, "new":n%2})
	return append_binary_leading_zeros(binary.reverse())
