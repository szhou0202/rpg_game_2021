extends StaticBody2D

export var ACC = 300
export var MAX_SPEED = 50
export var FRICTION = 200

#enum move_states {
#	IDLE,
#	WANDER
#}

# var state = move_states.IDLE
# var quest_status = quest_states.NOT_STARTED
# var dialogue_state = 0
var potion_found = false # unnecessary now
# var vel = Vector2.ZERO

onready var animatedSprite = $AnimatedSprite
onready var animationPlayer = $AnimationPlayer
onready var pdz = $NPCPlayerDetectionZone
onready var dialogue = get_tree().root.get_node("World/CanvasLayer/WizardDialogue/DialogueBox")
onready var reg = get_tree().root.get_node("World/YSort/Regele")
onready var small = get_tree().root.get_node("World/YSort/Small")
# onready var wanderController = $WanderController
# onready var xkey = $XKey

func _ready():
	animatedSprite.animation = "Animate"
	animationPlayer.play("Animate")

func _process(delta):
	if small.duck_found:
		dialogue.state = dialogue.QUEST_STATE.FINISHED
	
	# telling regele to go, linear plot 
	if dialogue.state == dialogue.QUEST_STATE.STARTED:
		reg.reg_go = true # reg can start dialogue

#func _physics_process(delta):
#	match state:
#		move_states.IDLE: 
#			vel = vel.move_toward(Vector2.ZERO, FRICTION * delta)
#			
#			# if time is up, bat chooses to idle more or wander
#			if wanderController.get_time_left() == 0:
#				update_wander()
#		move_states.WANDER:
#			# seek_player() # why do we need a seek_player call here?
#			
#			# when time is up for wandering, bat picks random state again
#			if wanderController.get_time_left() == 0:
#				update_wander()
#			
#			# move toward target_position
#			accelerate_to(wanderController.target_position, delta)
#			
#			# when the bat is close enough to target position, it can idle or wander more instead of bobbing back and forth
#			if global_position.distance_to(wanderController.target_position) <= 4:
#				update_wander()
#	vel = move_and_slide(vel)
#	
# to pick rand state and start timer
#func update_wander():
#	state = pick_random_state([move_states.IDLE, move_states.WANDER])
#	wanderController.start_wander_timer(rand_range(1,3))
#
# to move towards a position
#func accelerate_to(point, delta):
#	var direction = global_position.direction_to(point).normalized()
#	vel = vel.move_toward(direction * MAX_SPEED, ACC * delta)
#	animatedSprite.flip_h = vel.x < 0

# function to pick random state from a list of states
#func pick_random_state(state_list):
#	state_list.shuffle()
#	return state_list.pop_front()

func _on_NPCPlayerDetectionZone_body_entered(body):
	animatedSprite.animation = "Outline"
	animationPlayer.play("Outline")
	dialogue.in_PDZ = true
	# xkey.visible = true # keyboard controller indicator pops up

func _on_NPCPlayerDetectionZone_body_exited(body):
	animatedSprite.animation = "Animate"
	animationPlayer.play("Animate")
	dialogue.in_PDZ = false
	# xkey.visible = false
