extends Control

func _ready() -> void:
	
	build_buttons()
	
	var VBC:VBoxContainer=$CC/VBC
	var exit_btn:Button=Button.new()
	exit_btn.name="exit"
	exit_btn.text="Exit"
	VBC.add_child(exit_btn)
	var code:int=exit_btn.connect("pressed", Callable(get_tree(), "quit"), CONNECT_DEFERRED)
	assert(code==OK, "Failed to connect exit button to get_tree().quit(): {0}".format([code]))

func build_buttons() -> void:
	const IGNORE:String="menu"
	var VBC:VBoxContainer=$CC/VBC
	for dir in DirAccess.get_directories_at("res://modes/"):
		if dir == IGNORE: continue
		var button:Button=Button.new()
		button.name=dir
		button.text=lazy_naming(dir)
		VBC.add_child(button)
		var code:int=button.connect("pressed", Callable(Runner, "change_scene_to").bind(dir), CONNECT_DEFERRED)
		assert(code==OK, "Failed to connect button {0} to change_scene_to. {1}".format([dir, code]))

func lazy_naming(dir:String) -> String:
	if dir == "convert": return "Convert"
	elif dir == "truthtable": return "Truth table"
	return "NULL"
