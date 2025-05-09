extends CharacterBody3D

var camera: Camera3D;
var head : Node3D;
var move_speed: float = 5.0;
var jump_force: float = 5.0;

# how fast does the camera react to mouse movement
var look_sens: float = 0.5;
var gravity: float = 9.0;

# how far can the camera look down
var min_x_rotation: float = -85.0;
# how far the camera can look up.
var max_x_rotation: float = 85.0;

var mouse_direction: Vector2;

func _ready():
	camera = get_node("Camera3D")
	head = get_node("Head")
	remove_child(camera)
	
	# make the camera a child of the root/main node once everything is fully initalized (call deferred)
	get_node("/root/Main").add_child.call_deferred(camera);

func _input(event):
	if event is InputEventMouseMotion:
		camera.rotation_degrees.x += event.relative.y * -look_sens;
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, min_x_rotation, max_x_rotation);
		
		camera.rotation_degrees.y += event.relative.x * -look_sens;
	pass
	
func _process(delta):
	# makes it so the camera follows the head by updating its position every frame.
	camera.position = head.global_position;
	pass
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta/5;
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force;
	
	# takes inputs from input maps and turns it into a vector you can use modify player position
	var input = Input.get_vector("move_left", "move_right", "move_foward", "move_back");
	var dir = camera.basis.z * input.y + camera.basis.x * input.x;
	
	# makes it so looking down doesn't slow you down
	dir.y = 0;
	dir = dir.normalized()
	
	velocity.x = dir.x * move_speed;
	velocity.z = dir.z * move_speed;	
	
	move_and_slide()  

	pass
