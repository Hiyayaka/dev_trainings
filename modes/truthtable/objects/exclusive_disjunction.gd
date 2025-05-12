class_name Exclusive_Disjunction
extends Token

const OPERATOR_LIST:Array=["xor","⊕"]

func build_formula() -> bool:
	if !next:
		expression.error="Exclusive Disjunction missing right hand side object."
		return false
	if next is Identifier or next is OExpression or next is Negation:
		pass
	else:
		expression.error="Exclusive Disjunction right hand side is not Identifier nor Expression."
		return false
	if !prev:
		expression.error="Exclusive Disjunction missing left hand side object."
		return false
	if name.length() == 1:
		formula="{left}{name}{right}".format({"right":next.formula, "left":prev.formula, "name":name})
	else:
		formula="{left} {name} {right}".format({"right":next.formula, "left":prev.formula, "name":name})
	return true


func build_values() -> void:
	for i in range(prev.values.size()):
		if bool(prev.values[i]) == true and bool(next.values[i]) == false or bool(prev.values[i]) == false and bool(next.values[i]) == true:
			values.append(1)
		else:
			values.append(0)
	expression.rem(prev)
	expression.rem(next)

func identify(raw:String) -> int:
	if OPERATOR_LIST.has(raw[0]):
		return 1
	elif OPERATOR_LIST.has(raw.substr(0, 3)):
		return 3
	return 0

func new() -> Exclusive_Disjunction:
	return Exclusive_Disjunction.new()
