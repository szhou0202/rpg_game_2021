extends KinematicBody2D

const DeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

var knockback = Vector2.ZERO

export var ACC = 300
export var MAX_SPEED = 50
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = CHASE
var vel = Vector2.ZERO

onready var stats = $Stats
onready var pdz = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtbox = $HurtBox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer

# at ready bat idles or wanders
func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE: 
			vel = vel.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
			# if time is up, bat chooses to idle more or wander
			if wanderController.get_time_left() == 0:
				update_wander()
		WANDER:
			# seek_player() # why do we need a seek_player call here?
			
			# when time is up for wandering, bat picks random state again
			if wanderController.get_time_left() == 0:
				update_wander()
			
			# move toward target_position
			accelerate_to(wanderController.target_position, delta)
			
			# when the bat is close enough to target position, it can idle or wander more instead of bobbing back and forth
			if global_position.distance_to(wanderController.target_position) <= 4:
				update_wander()
		CHASE:
			var player = pdz.player
			if player != null:
				accelerate_to(player.global_position, delta)
			else:
				state = IDLE
	
	# if there is a soft collision, bat will be pushed back a little
	if softCollision.is_colliding():
		vel += softCollision.get_push_vector() * delta * 400
	vel = move_and_slide(vel)

# to pick rand state and start timer
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1,3))

# to move towards a position
func accelerate_to(point, delta):
	var direction = global_position.direction_to(point).normalized()
	vel = vel.move_toward(direction * MAX_SPEED, ACC * delta)
	sprite.flip_h = vel.x < 0

# func on signal, knocks bat back, decreases health, creates hit effect
func _on_HurtBox_area_entered(area):
	knockback = area.knockback_vector * 120
	stats.health -= area.damage
	hurtbox.create_hit_effect()
	hurtbox.start_invinc(0.4)

# function to pick random state from a list of states
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Stats_no_health():
	queue_free()
	create_death_effect()

func create_death_effect():
	var death = DeathEffect.instance()
	get_parent().add_child(death)
	death.global_position = global_position
	
func seek_player():
	if pdz.can_see_player():
		state = CHASE

# blink animation stop
func _on_HurtBox_invinc_ended():
	animationPlayer.play("Stop")

# blink animation start
func _on_HurtBox_invinc_started():
	animationPlayer.play("Start")
