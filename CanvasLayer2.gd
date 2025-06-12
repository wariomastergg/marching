
extends CanvasLayer


# Called when the node enters the scene tree for the first time.
var pos = Vector3(0,0,0)
var mov = Vector2(0,0)
var ang = Vector2(0,0)
func _ready():
	
	
	#var image = Sprite2D() 
	
	$ColorRect.material.set("shader_parameter/voxels", [1,1,1,1,1])
	
	pos = $ColorRect.material.get("shader_parameter/pt")
	ang = $ColorRect.material.get("shader_parameter/a")
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Called every frame. 'delta' is the elapsed time since the previous frame.
var spd = 0.1
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if  Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		ang += Input.get_last_mouse_velocity()/100.0

	
	mov = Vector2(0,0)
	if Input.is_action_pressed("up"):
		mov.y -= spd
	if Input.is_action_pressed("down"):
		mov.y += spd
	if Input.is_action_pressed("left"):
		mov.x -= spd
	if Input.is_action_pressed("right"):
		mov.x += spd
	
	if Input.is_action_pressed("rise"):
		pos.x += spd
	if Input.is_action_pressed("fall"):
		pos.x -= spd
	
	mov = mov.normalized()*spd
	pos.z += cos(deg_to_rad(-ang.x))*mov.y
	pos.y += sin(deg_to_rad(-ang.x))*mov.y
	
	pos.z += cos(deg_to_rad(-ang.x+90))*mov.x
	pos.y += sin(deg_to_rad(-ang.x+90))*mov.x

	
	$ColorRect.material.set("shader_parameter/pt", pos)
	$ColorRect.material.set("shader_parameter/a", ang)
