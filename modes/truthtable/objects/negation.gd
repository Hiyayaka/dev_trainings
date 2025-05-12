class_name Negation
extends Token

const OPERATOR_LIST:Array=["!", "¬", "~", "not"]

func _ready() -> void:
	name="Negation"

func build_formula() -> bool:
	if !next:
		expression.error="Negation missing right hand side object."
		return false
	elif next is Identifier or next is OExpression:
		if name.length() == 1:
			formula="{name}{right}".format({"right":next.formula,"name":name})
		else:
			formula="{name} {right}".format({"right":next.formula,"name":name})
		return true
	else:
		expression.error="Negation right hand side object is not identifier or expression."
		return false

func build_values() -> void:
	if next:
		for value in next.values:
			values.append(!value)
	expression.rem(next)

func identify(raw:String) -> int:
	if OPERATOR_LIST.has(raw[0]):
		return 1
	elif OPERATOR_LIST.has(raw.substr(0, 3)):
		return 3
	return 0

func new() -> Negation:
	return Negation.new()
