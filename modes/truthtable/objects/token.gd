class_name Token
extends Object

var prev=null
var next=null
var expression:OExpression=null

var name:String=""
var formula:String=""
var values:Array=[]

func get_start():
	var target:Token=self
	while target.prev!=null:
		target=target.prev
	return target

func get_pos(position:int) -> Token:
	var target:Token=self
	while position > 0:
		target=target.next
		position-=1
	return target

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
	TEST_get_pos()
	TEST_get_start()
