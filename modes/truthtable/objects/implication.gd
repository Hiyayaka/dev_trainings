class_name Implication
extends Operator

##When values are calculated, gives true if left hand [Token] is lower or same value as right hand side.

##All the possible symbols for this operator
const OPERATOR_LIST:Array=[">","->","=>"]

##Values build function for this operator. Removes left and right hand side Tokens after calculation is completed.
func build_values() -> void:
	for i in range(prev.values.size()):
		if int(prev.values[i]) <= int(next.values[i]):
			values.append(1)
		else:
			values.append(0)
	expression.rem(prev)
	expression.rem(next)

##Identify this operator from raw string. returns the length of identified members
func identify(raw:String) -> int:
	if OPERATOR_LIST.has(raw[0]):
		return 1
	elif OPERATOR_LIST.has(raw.substr(0, 2)):
		return 2
	return 0

##Rolls random name from OPERATOR_LIST
func roll_name() -> void:
	name=OPERATOR_LIST.pick_random()

##Gives new Object of this type.
func new() -> Implication:
	return Implication.new()

func get_class_name() -> String:
	return "Implication"
