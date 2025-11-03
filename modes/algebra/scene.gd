extends Control

var formula:Formula=Formula.new()

func _ready() -> void:
	var edit:LineEdit=$CC/VBC/answer
	var code:int=edit.connect("text_changed", Callable(self, "compile_string"), CONNECT_DEFERRED)
	assert(code==OK, "Failed to connect answer to check_answer: {0}".format([code]))

func compile_string(new_text:String) -> void:
	if formula.read_tokens_from_string(new_text) == false:
		create_error_message(formula.error)
	else:
		clear_messages()
		draw_formula()

func draw_formula() -> void:
	var expression:Expression
	var d:Panel=$CC/VBC/draw/CC
	var font:Font=get_theme_default_font()
	for token in formula.token_list:
		var instructions:Dictionary=token.draw()
		if instructions.command == "draw_label":
			var label:Label=Label.new()
			label.text=instructions.data
			
			
		#Token may output following things:
		#	* value (number)
		#	* symbol (variable name, operator name)
		#	* symbol + influence (change positions and size of previous and next tokens)

##Check for token errors. If formula compilation fails they will leave error message about it.
func check_token_errors() -> void:
	pass

func create_error_message(new_message:String):
	clear_messages()
	var messages_VBC:VBoxContainer=$messages
	var label:Label=Label.new()
	label.text=new_message
	messages_VBC.add_child(label)

#Remove all message labels.
func clear_messages() -> void:
	var messages:VBoxContainer=$messages
	for i in range(messages.get_child_count()):
		var child=messages.get_child(0)
		messages.remove_child(child)
		child.queue_free()
