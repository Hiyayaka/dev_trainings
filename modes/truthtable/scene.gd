extends Control

var expression:OExpression=OExpression.new()

func _ready() -> void:
	var back_btn:Button=$hbc/back
	var code:int=back_btn.connect("pressed", Callable(Runner, "change_scene_to").bind("menu"), CONNECT_DEFERRED)
	assert(code==OK, "Failed to connect back button to change_scene_to. {0}".format([code]))

	var edit:LineEdit=$CC/VBC/edit
	code=edit.connect("text_changed", Callable(self, "compile_string"), CONNECT_DEFERRED)
	assert(code==OK, "Failed to connect edit to string_to_expression. {0}".format([code]))

	

	#for i:int in range(3):
		#create_identifier()
	#
	#expression.calculate_identifier_values()
	#expression.calculate_negative_values()


func compile_string(new_string:String)->void:
	if expression.read_tokens_from_string(new_string):
		calc_and_update_truth_table()
	else:
		create_fail_message()

const OPERATION_FUNCTION_NAMES:Array=[
	"get_negatives",
	"get_conjunctions",
	"get_disjunctions",
	"get_exclusive_disjunctions",
	"get_implications",
	"get_equivalences",
]

func calc_and_update_truth_table():
	clear_truth_table()
	#Identifiers
	if not expression.calculate_identifier_values():
		create_fail_message()
		return
	var identifiers=expression.get_identifiers()
	identifiers = expression.remove_double_identifiers(identifiers)
	draw_token(identifiers)

	calc_and_update_operators(expression)

#remove last seperator
	var truth_table:HBoxContainer=$CC/VBC/truth_table
	var last=truth_table.get_child(truth_table.get_child_count()-1)
	if last is VSeparator:
		last.queue_free()

func calc_and_update_operators(target:OExpression):
	var expressions:Array=target.get_expressions()
	for exp in expressions:
		calc_and_update_operators(exp)
	
	for function in OPERATION_FUNCTION_NAMES:
		if not target.calculate_token_values(target.call(function)):
			create_fail_message()
			return
		draw_token(target.call(function))
	
	if not target.calculate_token_values([target]):
		create_fail_message()

func create_fail_message() -> void:
	clear_truth_table()
	var truth_table:HBoxContainer=$CC/VBC/truth_table
	var label:Label=Label.new()
	label.text=expression.error
	truth_table.add_child(label)

func create_identifier() -> void:
	var identifier:Identifier=Identifier.new()
	expression.add(identifier)
	identifier.roll_identifier_name()

func clear_truth_table() -> void:
	var truth_table:HBoxContainer=$CC/VBC/truth_table
	while truth_table.get_child_count() > 0:
		var child = truth_table.get_child(0)
		truth_table.remove_child(child)
		child.queue_free()

func draw_token(tokens) -> void:
	var truth_table:HBoxContainer=$CC/VBC/truth_table
	for token in tokens:
		var VBC:VBoxContainer=VBoxContainer.new()
		truth_table.add_child(VBC)
		truth_table.add_child(VSeparator.new())
		var name_label:Label=Label.new()
		name_label.text=token.formula
		name_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
		VBC.add_child(name_label)
		for value in token.values:
			var value_label:Label=Label.new()
			value_label.text="T" if value else "F"
			value_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
			VBC.add_child(value_label)
