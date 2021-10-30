extends Node2D

export(int) var wander_range = 32

# remembering start position when bat is instanced in room
onready var start_position = global_position

# target pos for bat to wander to, but never too far from start
onready var target_position = global_position

onready var timer = $Timer

# ready creates a new target poistion
func _ready():
	update_target_position()

# to update var target position
func update_target_position():
	
	# target vector is a random vector with x and y within wander_range
	var target_vector = Vector2(rand_range(-wander_range,wander_range), rand_range(-wander_range,wander_range))
	
	# update target position
	target_position = start_position + target_vector

# gets time left on timer
func get_time_left():
	return timer.time_left

# start timer with duration
func start_wander_timer(duration):
	timer.start(duration)

# func to call update_target_position every __ seconds
func _on_Timer_timeout():
	update_target_position()
