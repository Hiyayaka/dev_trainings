class_name Implication
extends Token

const OPERATOR_LIST:Array=[">","->","=>"]

func build_formula() -> bool:
	if !next:
		expression.error="Implication missing right hand side object."
		return false
	if next is Identifier or next is OExpression or next is Negation:
		pass
	else:
		expression.error="Implication right hand side is not Identifier or Expression"
		return false
	if !prev:
		expression.error="Implication missing left hand side object."
		return false
	if name.length() == 1:
		formula="{left}{name}{right}".format({"right":next.formula, "left":prev.formula, "name":name})
	else:
		formula="{left} {name} {right}".format({"right":next.formula, "left":prev.formula, "name":name})
	return true


func build_values() -> void:
	for i in range(prev.values.size()):
		if int(prev.values[i]) <= int(next.values[i]):
			values.append(1)
		else:
			values.append(0)
	expression.rem(prev)
	expression.rem(next)

func identify(raw:String) -> int:
	if OPERATOR_LIST.has(raw[0]):
		return 1
	elif OPERATOR_LIST.has(raw.substr(0, 2)):
		return 2
	return 0

func new() -> Implication:
	return Implication.new()
