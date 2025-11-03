class_name Disjunction
extends Operator

##When values are calculated, gives true if either left and right hand Tokens has true as a value.

##All the possible symbols for this operator
const OPERATOR_LIST:Array=["v","|","or"]

##Values build function for this operator. Removes left and right hand side Tokens after calculation is completed.
func build_values() -> void:
	for i in range(prev.values.size()):
		if bool(prev.values[i]) == true or bool(next.values[i]) == true:
			values.append(1)
		else:
			values.append(0)
	expression.rem(prev)
	expression.rem(next)

##Identify this operator from raw string. returns the length of identified members
func identify(raw:String) -> int:
	raw=raw.to_lower()
	if OPERATOR_LIST.has(raw[0]):
		return 1
	elif OPERATOR_LIST.has(raw.substr(0, 2)):
		return 2
	return 0

##Rolls random name from OPERATOR_LIST
func roll_name() -> void:
	name=OPERATOR_LIST.pick_random()

##Gives new Object of this type.
func new() -> Disjunction:
	return Disjunction.new()

func get_class_name() -> String:
	return "Disjunction"
