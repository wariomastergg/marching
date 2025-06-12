@tool
extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	var a = get_viewport().get_visible_rect().size
	print(a)
	material.set("shader_parameter/wi", a.x)
	material.set("shader_parameter/hi", a.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
