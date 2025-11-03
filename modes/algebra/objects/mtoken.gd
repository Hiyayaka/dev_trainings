class_name MToken
extends Object

##Base class for everything math related.

var prev:MToken=null##Handy link for right and left hand side objects.
var next:MToken=null##Handy link for right and left hand side objects.
##Quick link to formula wich holds this token.
var owned_by:Formula=null

var symbol:String = "" ##Symbol in the math formula

var value=null: ##If the symbol holds a value, it will be stored here. If null, no value.
	get:
		return value
	set(new_value):
		assert(new_value is int or new_value is float or new_value == null, "variable type needs to be int or float.")
		if new_value is int or new_value is float or new_value == null:
			value=new_value
		else:
			error_msg="Value can be only whole number or real number. Attemped to set to {0}".format([type_string(typeof(new_value))])

var error_msg:String="" ##Will hold the error message if something fails.

func draw() -> Dictionary:
	return {
		"command":"", #String type
		"data":"", #Supported types (String,)
		"influence":"",
		}

func clear() -> void:
	unlink()
	owned_by=null
	symbol=""
	value=null
	error_msg=""

func unlink() -> void:
	if prev:
		var prev_token:MToken=prev
		if next:
			prev_token.next=next
		else:
			prev_token.next=null
	if next:
		var next_token:MToken=next
		if prev:
			next_token.prev=prev
		else:
			next_token.prev=null
	prev=null
	next=null

func check(from:String=""):
	if !prev: error_msg="Missing left hand operand{0}".format(["for {0}".format([from])])
	if !next: error_msg="Missing right hand operand{0}".format(["for {0}".format([from])])

func new() -> MToken:
	return MToken.new()

func copy() -> MToken:
	var new:MToken=MToken.new()
	new.symbol=symbol
	new.value=value
	return new
