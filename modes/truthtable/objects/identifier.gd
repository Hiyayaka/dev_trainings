class_name Identifier
extends Token

##Identifier will get generated to have starting values before calculations.[br]
##Values will be calculated in such manner that every row of values will be unique.

##Name list will hold all possible names for truth table.
const NAME_LIST:Array=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","x","y","z",
"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","X","Y","Z"]

func _ready() -> void:
	name="NULL"

##Rolls name for Identifier
static func roll_identifier_name() -> String:
	return NAME_LIST.pick_random()

##Identify this Identifier from raw string. returns the length of identified members
func identify(raw:String) -> int:
	if NAME_LIST.has(raw[0]):
		return 1
	return 0

##Gives new Object of this type.
func new() -> Identifier:
	return Identifier.new()

func get_class_name() -> String:
	return "Identifier"
