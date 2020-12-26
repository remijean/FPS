extends KinematicBody

signal state_changed(state, delta)

enum { IDLE, WALK, JUMP, FALL }

const GRAVITY := -15
const JUMP_FORCE := 5
const MOUSE_SENSITIVITY := 0.005
const SPEED := 10

var health := 100.0
var velocity := Vector3()
var state = FALL

onready var head = $Head

func _input(event):
	# Rotation
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		head.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

func _process(_delta):
	# Death
	if(health <= 0):
		queue_free()

func _physics_process(delta):
	# Direction
	var x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var direction = transform.basis.xform(Vector3(x, 0, z)).normalized() * SPEED
	
	# State
	if is_on_floor() and Input.is_action_just_pressed("move_jump"):
		set_state(JUMP, delta)
	elif is_on_floor() and !direction:
		set_state(IDLE, delta)
	elif is_on_floor() and direction:
		set_state(WALK, delta)
	else:
		set_state(FALL, delta)
	
	# Gravity
	velocity.y += GRAVITY * delta
	var snap = Vector3.DOWN
	
	# Jump
	if state == JUMP:
		velocity.y = JUMP_FORCE
		snap = Vector3.ZERO
	
	# Movement
	velocity = move_and_slide_with_snap(Vector3(direction.x, velocity.y, direction.z), snap, Vector3.UP, true)

func set_state(new_state, delta):
	emit_signal("state_changed", new_state, delta);
	state = new_state
