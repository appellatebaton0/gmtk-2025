extends CharacterBody2D
class_name Player

const SPEED = 60.0
const JUMP_VELOCITY = -160.0

const GRAVITY_MOD:float = 0.6

const ACCELERATION:float = 25.0
const FRICTION:float = 30.0

const JUMP_BUFFERING:float = 0.1
var jump_buffer:float = 0.0

const COYOTE_TIME:float = 0.1
var coyote_time:float = 0.1


func control(delta):
	modulate.a = move_toward(modulate.a, 1.0, delta * 5)
	
	# Jump Buffering
	jump_buffer = move_toward(jump_buffer, 0, delta)
	if Input.is_action_just_pressed("Jump"):
		jump_buffer = JUMP_BUFFERING
	
	# Coyote Time
	coyote_time = move_toward(coyote_time, 0, delta)
	if is_on_floor():
		coyote_time = COYOTE_TIME
	
	# Handle jump.
	if jump_buffer > 0 and coyote_time > 0:
		velocity.y = JUMP_VELOCITY
		
		jump_buffer = 0
		coyote_time = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	
	move_and_slide()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and len(get_tree().get_nodes_in_group("Levels")) > 0:
		velocity += get_gravity() * GRAVITY_MOD * delta
	if self != Global.current_player:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	move_and_slide()
