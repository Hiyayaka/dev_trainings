class_name Identifier
extends Token

const NAME_LIST:Array=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","x","y","z",
"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","X","Y","Z"]

func _ready() -> void:
	name="NULL"

func roll_identifier_name() -> bool:
	for i:int in range(1000):
		var ID:int=randi_range(0, NAME_LIST.size()-1)
		if not expression_has_identifier(NAME_LIST[ID], expression.data):
			name=NAME_LIST[ID]
			formula=name
			return true
	return false

func expression_has_identifier(identifier_name:String, data:Array) -> bool:
	for object in data:
		if object is Identifier and object.name == identifier_name:
			return true
	return false

func identify(raw:String) -> int:
	if NAME_LIST.has(raw[0]):
		return 1
	return 0

func new() -> Identifier:
	return Identifier.new()
