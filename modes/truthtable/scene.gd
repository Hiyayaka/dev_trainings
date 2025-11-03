extends Control

#truth table compiles user input here.
var expression:OExpression=OExpression.new()
#Question formula is rolled here.
var question_expression:OExpression

func _ready() -> void:
	var back_btn:Button=$hbc/back
	var code:int=back_btn.connect("pressed", Callable(Runner, "change_scene_to").bind("menu"), CONNECT_DEFERRED)
	assert(code==OK, "Failed to connect back button to change_scene_to. {0}".format([code]))

	var edit:LineEdit=$CC/VBC/edit
	code=edit.connect("text_changed", Callable(self, "compile_string"), CONNECT_DEFERRED)
	assert(code==OK, "Failed to connect edit to string_to_expression. {0}".format([code]))

	var reroll_btn:Button=$hbc/reroll
	code=reroll_btn.connect("pressed", Callable(self, "reroll_question"), CONNECT_DEFERRED)
	assert(code==OK, "Failed to connect button to reroll_question: {0}".format([0]))

	question_expression=roll_formula(0)
	#formula_data.append(roll_formula(0))
	update_question()

func reroll_question() -> void:
	token_count=0
	question_expression.clear()
	rolled_identifier_names.clear()
	rolled_identifiers.clear()
	question_expression=roll_formula(0)
	update_question()

func update_question() -> void:
	var question:Label=$CC/VBC/question
	question.text=question_expression.formula

#Token count will hold total amount of tokens in a formula. Its global to easyer access recursive roll_formula function
var token_count:int=0

#Randomizes the questions for user.
#Full of edge cases, ugly as hell. But it does WORK O_O
func roll_formula(sub_lvl:int) -> OExpression:
	var max_tokens_spinbox:SpinBox=$hbc/max_tokens_spinbox
	var max_identifiers_spinbox:SpinBox=$hbc/max_identifiers_spinbox
	var formula_expression:OExpression=OExpression.new()

	var last=null

	var data=formula_expression.data

	while token_count < max_tokens_spinbox.value:
#Only allow bracers if last element is not a Identifier or Expression. (Also can be on start, hence !last)
		if !last or last is not Identifier and last is not OExpression:
			if token_count + 4 < max_tokens_spinbox.value:
				if !randi()%4:
					token_count+=1
					data.append(roll_formula(sub_lvl+1))
					last=data[-1]
					continue

#Roll operator if the last is Identifier or Expression
		if last is Identifier or last is OExpression:
			roll_operator_to(data)

#Roll new identifier if last is not another Identifier or Expression
		if !last or last is not Identifier and last is not OExpression:
#Pops negaton in 25% cases
			if roll_negation_to(data): token_count+=1
			roll_identifier_to(max_identifiers_spinbox.value, data)
#After a Identifier we may stop Expression (braces) if we are doing sub Expression. Pops end on 50% rate.
			if data.size() > 2 and sub_lvl > 0:
				if randi()%2:
					formula_expression.create_formula(true)
					return formula_expression

		token_count+=1
		last=data[-1]
	
	#fix possible missing last member
	if last is not Identifier and last is not OExpression:
		roll_negation_to(data)
		roll_identifier_to(max_identifiers_spinbox.value, data)

	formula_expression.create_formula(bool(sub_lvl))
	return formula_expression

#can be replaced whit function pointers.
var OPERATORS_LIST:Array=[
	Conjunction.new(),
	Disjunction.new(),
	Exclusive_Disjunction.new(),
	Implication.new(),
	Equivalence.new(),
]

#Pops in new random operator to list.
func roll_operator_to(data_list:Array):
	var operator=OPERATORS_LIST.pick_random().new()
	operator.roll_name()
	data_list.append(operator)

#Randomly pops negation to list.
func roll_negation_to(data_list:Array) -> bool:
	var do_it:bool=!randi()%4 #will do about 25% change ?
	if do_it:
		var negaton=Negation.new()
		negaton.roll_name()
		data_list.append(negaton)
		return true
	return false

#Rolls random identifier to list. Doesn't exceed max value, rolls old name in that case.
var rolled_identifier_names:Array=[]
var rolled_identifiers:Array=[]
func roll_identifier_to(total_max:int, data_list:Array):
	var identifier:Identifier
	if rolled_identifier_names.size() < total_max:
		var new_name:String=Identifier.roll_identifier_name()
		if not rolled_identifier_names.has(new_name):
			rolled_identifier_names.append(new_name)
			identifier=Identifier.new()
			identifier.name = new_name
			identifier.formula = new_name
			rolled_identifiers.append(identifier)
		else:
			var pos:int=rolled_identifier_names.find(new_name)
			identifier=rolled_identifiers[pos]
	else:
		identifier=rolled_identifiers.pick_random()
	data_list.append(identifier)

#Attemp to compile user input to a formula
func compile_string(new_string:String)->void:
	if expression.read_tokens_from_string(new_string):
		calc_and_update_truth_table()
	else:
		create_fail_message()

#Actin as function pointers (again)
#also as a side efffect decides order of operations.
const OPERATION_FUNCTION_NAMES:Array=[
	"get_negatives",
	"get_conjunctions",
	"get_disjunctions",
	"get_exclusive_disjunctions",
	"get_implications",
	"get_equivalences",
]

#Calculate compiled string to truth table.
#Compilation and drawing is done in turns.
func calc_and_update_truth_table():
	clear_truth_table()
	#all the Identifiers in any of the Expressions (includes the sub Expressions too)
	if not expression.calculate_identifier_values():
		create_fail_message()
		return
	var identifiers=expression.get_identifiers()
	identifiers = expression.remove_double_identifiers(identifiers)
	draw_token(identifiers)

	if not calc_and_update_operators(expression):
		return

#remove last seperator
	var truth_table:HBoxContainer=$CC/VBC/truth_table
	var last=truth_table.get_child(truth_table.get_child_count()-1)
	if last is VSeparator:
		last.queue_free()

#Recursive function. May enter sub Expressions if present
func calc_and_update_operators(target:OExpression) -> bool:
#Find and enter to possible sub Expression.
	var expressions:Array=target.get_expressions()
	for target_exrepssion in expressions:
		if not calc_and_update_operators(target_exrepssion):
			expression.error=target_exrepssion.error
			create_fail_message()
			return false

#1. Need to process negatives first
	var negations_list:Array=target.get_negatives()
	for token in negations_list:
		if not target.calculate_token_value(token):
			create_fail_message()
			return false
		draw_token([token])
#2. After we need to process operatos in left to right.
	var all_operators_expect_negations:Array=target.get_all_operators(["Negations"])
	for token in all_operators_expect_negations:
		if not is_instance_valid(token): continue
		if not target.calculate_token_value(token):
			create_fail_message()
			return false
		draw_token([token])



#Calculate and display tokens in Expressions. Side effect will decide order of operations.
#Remove this, doesn't calculate in correct order.
	#for function in OPERATION_FUNCTION_NAMES:
		#var token_list:Array=target.call(function)
		#for token in token_list:
			#if not target.calculate_token_value(token):
				#create_fail_message()
				#return false
			#draw_token([token])

#Update this Expression to have values for next calculations.
	if not target.calculate_token_value(target):
		create_fail_message()
	return true

#Create message informing error in procressing tokens.
func create_fail_message() -> void:
	clear_truth_table()
	var truth_table:HBoxContainer=$CC/VBC/truth_table
	var label:Label=Label.new()
	label.text=expression.error
	truth_table.add_child(label)

#Clear old result from truth table
func clear_truth_table() -> void:
	var truth_table:HBoxContainer=$CC/VBC/truth_table
	while truth_table.get_child_count() > 0:
		var child = truth_table.get_child(0)
		truth_table.remove_child(child)
		child.queue_free()

#Universal way to draw a any token to truth table.
func draw_token(tokens:Array) -> void:
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
