class_name MVariable
extends MToken

##Will hold variable data. Variables hold values.[br]
##Variables can be known (has value in it) or unknown (only letter is known).

func draw() -> Dictionary:
	if symbol.length() > 0 or value != null:
		var msg:String=symbol if symbol.length() > 0 else "{0}".format([value])
		return {"command":"draw_label",
				"data":"{0}".format([msg])}
	return {}

##Atm support only 1 letter long identifiers
func identify(raw:String) -> int:
	clear()
	#Check if the raw includes a number.
	var buildup:String=""
	var temp:String="" #Store raw input here first. Helps so that I dont need to delete things.
	var fl:bool=true #fl stands for First Letter
	#Attemp to extract number.
	for rchar in raw:
		temp="{0}{1}".format([temp, rchar])
		#Accept letters only if they are numeric, first letter may be also + or -.
		#is_valid_float() doesn't detect + and - whitout numbers to be numeric.
		if temp.is_valid_float() or fl and temp == "-" or fl and temp == "+":
			buildup="{0}{1}".format([buildup, rchar])
		else:
			break
		fl = false

	if buildup.is_empty():
		symbol=raw[0]
		return 1
	else:
		#edge case. If only + or - is found whitout numbers, exit with 0 (Failure)
		if buildup.length() == 1 and buildup[0] == "+" or buildup.length() == 1 and buildup[0] == "-":
			return 0
		if buildup.is_valid_int():
			value=buildup.to_int()
		else:
			value=buildup.to_float()
		return buildup.length()

func new() -> MVariable:
	return MVariable.new()

func copy() -> MVariable:
	return super.copy()#Does this work ? :D

func _ready() -> void:
	TEST_identify()
	print("Success!")

func TEST_identify() -> void:
	#Testing how identify can pick up numbers if the number continues with letters.
	var clear_int_number:String="12"
	assert(identify(clear_int_number) == 2)
	assert(value == 12, "clear_int_number test failed.")

	var clear_float_number:String="5.35"
	assert(identify(clear_float_number) == 4)
	assert(value > 5.34 and value < 5.36, "clear_float_number test failed.")

	var clear_float_number_e:String="3e5"
	assert(identify(clear_float_number_e) == 3)
	assert(value > 299999 and value < 300001, "clear_float_number_e test failed.")

	var int_number_plus_symbol="30a"
	assert(identify(int_number_plus_symbol) == 2)
	assert(value == 30, "int_number_plus_symbol test failed.")

	var float_number_plus_symbol="2.45b"
	assert(identify(float_number_plus_symbol) == 4)
	assert(value > 2.44 and value < 2.46)

	var int_with_minus="-53"
	assert(identify(int_with_minus) == 3)
	assert(value == -53)

	var float_with_minus="-8.43"
	assert(identify(float_with_minus) == 5)
	assert(value < -8.42 and value > -8.44)

	var float_with_minus_e="-3e3"
	assert(identify(float_with_minus_e) == 4)
	assert(value < -2999 and value > -3001)

	var real_world_case="a+35"
	assert(identify(real_world_case) == 1)
	assert(symbol == "a" and value == null)

	var real_world_case2="35+a"
	assert(identify(real_world_case2) == 2)
	assert(symbol == "" and value == 35)

	var only_plus_sign="+"
	assert(identify(only_plus_sign) == 0)
	assert(symbol=="" and value == null)

	var only_minus_sign="-"
	assert(identify(only_minus_sign) == 0)
	assert(symbol=="" and value == null)
