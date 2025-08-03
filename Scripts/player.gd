extends CharacterBody2D
class_name Player

const SPEED = 45.0
const JUMP_VELOCITY = -80.0

const GRAVITY_MOD:float = 0.3

const ACCELERATION:float = 25.0
const FRICTION:float = 30.0

const JUMP_BUFFERING:float = 0.1
var jump_buffer:float = 0.0

const COYOTE_TIME:float = 0.1
var coyote_time:float = 0.1

@onready var anim:AnimatedSprite2D = $AnimatedSprite2D
@onready var nuh_uh:Label = $NuhUh

func die():
	if self == Global.current_player:
		var level:Level = get_tree().get_first_node_in_group("Levels")
		level.kill_player()

func control(delta):
	# Jump Buffering
	jump_buffer = move_toward(jump_buffer, 0, delta)
	if Input.is_action_just_pressed("Jump"):
		jump_buffer = JUMP_BUFFERING
	
	# Coyote Time
	coyote_time = move_toward(coyote_time, 0, delta)
	if is_on_floor():
		#if coyote_time == 0:
			## Ya *just* hit the floor. Particles and sfx?
			#Global.play_sfx.emit(load("res://Assets/SFX/land.wav"))
		coyote_time = COYOTE_TIME
	
	# Handle jump.
	if jump_buffer > 0 and coyote_time > 0:
		Global.play_sfx.emit(load("res://Assets/SFX/jump.wav"))
		
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
	
	if velocity.x != 0:
		anim.play("Walk")
		anim.flip_h = not velocity.x > 0
	else:
		anim.play("Idle")
	
	move_and_slide()

func vec_move_toward(a:Vector2, b:Vector2, delta:float) -> Vector2:
	a.x = move_toward(a.x, b.x, delta)
	a.y = move_toward(a.y, b.y, delta)
	return a

func _physics_process(delta: float) -> void:
	nuh_uh.modulate.a = move_toward(nuh_uh.modulate.a, 0, delta)
	# Add the gravity.
	if not is_on_floor() and len(get_tree().get_nodes_in_group("Levels")) > 0:
		velocity += get_gravity() * GRAVITY_MOD * delta
	if self != Global.current_player:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		if anim.animation == "Walk" or anim.animation == "Idle":
			anim.play("Die")
	anim.scale = vec_move_toward(anim.scale, Vector2.ONE + (abs(velocity) / 400), delta * 4)
	modulate.a = move_toward(modulate.a, 1.0, delta * 5)
	move_and_slide()


func _on_hurtbox_body_entered(_body: Node2D) -> void:
	die()
