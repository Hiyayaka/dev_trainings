class_name Token
extends Object

##Base class for [Operator] and [Identifier] + [Expression].


var prev=null##Handy link for right and left hand side objects.
var next=null##Handy link for right and left hand side objects.
##Quick link to expression wich holds this token.
var expression:OExpression=null

##Should be the name of the Identifier or operator symbol
var name:String=""
##Formula holds the partial data needed to show on truth table (what was calculated there)
var formula:String=""
##The actual truth values for this token.
var values:Array=[]

##Universal function to build formula for this Token.
func build_formula() -> bool:
	if name.length() == 1:
		formula="{left}{name}{right}".format({"right":next.formula, "left":prev.formula, "name":name})
	else:
		formula="{left} {name} {right}".format({"right":next.formula, "left":prev.formula, "name":name})
	return true

##Do a simple check that we have required members for calculations.
func check(_class_name:String) -> Array:
	var answer:Array=[]
	answer.append(true)
	if !next:
		answer[0] = false 
		answer.append("{class_name} missing right hand side object.".format({"class_name":_class_name}))
	if !prev:
		answer[0] = false 
		answer.append("{class_name} missing left hand side object.".format({"class_name":_class_name}))
	return answer

##Returns first member of the list.
func get_start():
	var target:Token=self
	while target.prev!=null:
		target=target.prev
	return target

##Returns requested position from the list.
func get_pos(position:int) -> Token:
	var target:Token=self
	while position > 0:
		target=target.next
		position-=1
	return target

##Unlinks the next and prev tokens from this token.
func unlink() -> void:
	if prev:
		if next:
			prev.next=next
		else:
			prev.next=null
	if next:
		if prev:
			next.prev=prev
		else:
			next.prev=null

#Some random tests
func TEST_get_pos():
	print("get_pos test.")
	print("Prep:")
	TEST_prep()
	#Test
	print("Test:")
	if "Token: 4" == get_pos(5).name:
		print("Success!")
	else:
		print("Failure: {0}".format([get_pos(5).name]))

func TEST_get_start():
	print("get_start test.")
	print("Prep:")
	TEST_prep()
	print("Test:")
	var token:Token=get_pos(7)
	if token.name != "Token: 6":
		print("Failure at getting token 6.")
	if token.get_start().name == "START":
		print("Success!")
	else:
		print("Failure!")

func TEST_prep() -> Array:
	var token_array:Array=[]
	for i in range(10):
		var new_token=Token.new()
		new_token.name="Token: {0}".format([i])
		token_array.append(new_token)
		if i > 0:
			new_token.prev=token_array[i-1]
			token_array[i-1].next=new_token
	next=token_array[0]
	token_array[0].prev=self
	name="START"
	return token_array

func _ready():
	pass
	#TEST_get_pos()
	#TEST_get_start()


func get_class_name() -> String:
	return "Token"
