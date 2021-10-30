extends KinematicBody2D

export var FRIC = 350
export var ACCEL = 300
export var MAX_SPEED = 80
export var ROLL_SPEED = 100

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var vel = Vector2.ZERO
var roll_vector = Vector2.RIGHT
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitBoxPivot/HitBox
onready var hurtbox = $HurtBox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	randomize() # to get a new random seed so things aren't the same
	stats.connect("no_health",self,"queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			roll_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		vel = vel.move_toward(input_vector * MAX_SPEED, ACCEL * delta)
	else:
		animationState.travel("Idle")
		vel = vel.move_toward(Vector2.ZERO, FRIC * delta)
	
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
func attack_state(delta):
	vel = Vector2.ZERO
	animationState.travel("Attack")
	
func roll_state(delta):
	vel = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()
	
func roll_animation_finished():
	vel = vel * 0.5
	state = MOVE
	
func attack_animation_finished():
	state = MOVE

func move():
	vel = move_and_slide(vel)

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invinc(0.6)
	hurtbox.create_hit_effect()

# when player is invincible ie has been hit by bat, play blinking
func _on_HurtBox_invinc_ended():
	blinkAnimationPlayer.play("Stop")

# when player is not invincible ie can be hit by bat again, stop blinking
func _on_HurtBox_invinc_started():
	blinkAnimationPlayer.play("Start")
