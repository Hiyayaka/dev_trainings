extends Node

func change_scene_to(mode:String) -> void:
	var root=get_tree().root
	var scene=root.get_node("scene")
	root.remove_child(scene)
	scene.queue_free()
	var path:String="res://modes/{mode}/scene.tscn".format({"mode":mode})
	var new_scene=load(path).instantiate()
	new_scene.name="scene"
	root.add_child(new_scene)
