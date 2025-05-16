extends Control

func _ready() -> void:
	randomize()
	var question:Label=$CC/VBC/question
	question.text = "INIT"
	
	var back_btn:Button=$HBC/back
	var code:int=back_btn.connect("pressed", Callable(Runner, "change_scene_to").bind("menu"), CONNECT_DEFERRED)
	assert(code==OK, "Failed to connect back_btn to Runner.change_scene_to. {0}".format([code]))

	var answer:LineEdit=$CC/VBC/answer
	code=answer.connect("text_submitted", Callable(self, "check_answer"), CONNECT_DEFERRED)
	assert(code==OK, "Failed to connect answer to check_answer: {0}".format([code]))

	var refresh_btn:Button=$HBC/refresh
	code=refresh_btn.connect("pressed", Callable(self, "ask_a_question"), CONNECT_DEFERRED)
	assert(code==OK, "Failed to connect refresh_btn to ask_a_question: {0}".format([code]))

#Load the convertion types
#These types need to have:
# func check_answer(string, int) #to check answers
# func convert_value(int) # to convert values for questions always from decimal to wanted type
# var type:String # to give a name
	var types:Node=$types
	types.add_child(load("res://modes/convert/types/binary.gd").new())
	types.add_child(load("res://modes/convert/types/decimal.gd").new())
	types.add_child(load("res://modes/convert/types/hexadecimal.gd").new())
		#if file_name.ends_with(".gd"):
			#var node:Node=load("res://modes/convert/types/{file_name}".format({"file_name":file_name})).new()
			#types.add_child(node)

	ask_a_question()

var from:Node=null
var to:Node=null

func check_answer(new_text:String) -> void:
	var result:Label=$CC/VBC/result
	result.text = to.check_answer(new_text, list[-1])
	ask_a_question()
	$CC/VBC/answer.clear()
	
	#var result:Label=$CC/VBC/result
	#new_text=new_text.dedent()
	#if not new_text.replace(" ", "").is_valid_int():
		#result.text="Not a int."
	#else:
		#new_text=append_binary_leading_zeros(new_text)
		#if not " " in new_text:
			#new_text = binary_insert_spaces(new_text)
		#var correct=get_binary(list[-1])
		#if new_text.replace(" ", "") == correct:
			#result.text="Correct answer: {0} == {1}".format([new_text, binary_insert_spaces(correct)])
		#else:
			#result.text="Wrong answer: {0} != {1}".format([new_text, binary_insert_spaces(correct)])
	#ask_a_question()
	#$CC/VBC/answer.clear()



const MAX:int=5
var list:Array=[]

func get_decimal(max:int) -> int:
	var custom:SpinBox=$HBC/custom_value
	if custom.value >= 0:
		if list.size() > MAX:
			list.pop_front()
		list.append(custom.value)
		return custom.value
	for i:int in range(1000):
		var n:int=randi_range(0, max)
		if not n in list:
			if list.size() > MAX:
				list.pop_front()
			list.append(n)
			return n
	return 0

var type_list:Array=[]

func ask_a_question() -> void:
	var types:Node=$types
	var from_ID:int
	var to_ID:int
	for i:int in range(1000):
		to_ID=randi_range(0, types.get_child_count()-1)
		from_ID=randi_range(0, types.get_child_count()-1)
		if from_ID != to_ID: break

	to=types.get_child(to_ID)
	from=types.get_child(from_ID)
	var question:Label=$CC/VBC/question
	var higest_value:SpinBox=$HBC/higest_value
	question.text="{0}({2}) to {1}".format([from.convert_value(get_decimal(higest_value.value)), to.type, from.type])
	
