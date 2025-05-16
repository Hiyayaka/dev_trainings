class_name Negation
extends Operator

##When values are calculated, gives opposite value of right hand side [Token].

##All the possible symbols for this operator
const OPERATOR_LIST:Array=["!", "¬", "~", "not"]

##Do a simple check that we have required members for calculations.
func check(_class_name:String) -> Array:
	var answer:Array=[]
	answer.append(true)
	if !next:
		answer[0] = false 
		answer.append("{class_name} missing right hand side object.".format({"class_name":_class_name}))
	elif next is Identifier or next is OExpression:
		pass
	else:
		answer[0] = false
		answer.append("{class_name} right hand side object is wrong type ({next_class_name}) it can be Identifier or Expression".format({"class_name":_class_name, "next_class_name":next.get_class_name()}))
	return answer

##Negation required some modifications to vs universal version
func build_formula() -> bool:
	if name.length() == 1:
		formula="{name}{right}".format({"right":next.formula,"name":name})
	else:
		formula="{name} {right}".format({"right":next.formula,"name":name})
	return true

##Values build function for this operator. Removes left and right hand side Tokens after calculation is completed.
func build_values() -> void:
	if next:
		for value in next.values:
			values.append(!value)
	expression.rem(next)

##Identify this operator from raw string. returns the length of identified members
func identify(raw:String) -> int:
	if OPERATOR_LIST.has(raw[0]):
		return 1
	elif OPERATOR_LIST.has(raw.substr(0, 3)):
		return 3
	return 0

##Rolls random name from OPERATOR_LIST
func roll_name() -> void:
	name=OPERATOR_LIST.pick_random()

##Gives new Object of this type.
func new() -> Negation:
	return Negation.new()

func get_class_name() -> String:
	return "Negation"
