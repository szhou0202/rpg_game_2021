extends Control

var dialogue = {
	0: 'Hello there good fellow. I\'ve lost my precious elixir. If you find my potion, you will be rewarded.',
	1: 'Still haven\'t found my potion? I believe in you!',
	2: 'You have found my potion! Thank you good fellow!'
}

# enum for quests
enum QUEST_STATE {
	NOT_STARTED,
	STARTED,
	FINISHED
}

var state = QUEST_STATE.NOT_STARTED
var dialogue_index
var quest_finished = false # unused
# var is_visible = false setget set_is_visible
var in_PDZ = false

func _ready():
	visible = false
	
# checks if key is pressed every delta
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") && in_PDZ:
		visible = true
		print("dialoguebox.visible = ", visible)
		get_tree().paused = true
		print("wizard dialogue entered")
		load_dialogue()
	if Input.is_action_just_pressed("ui_cancel") && in_PDZ:
		visible = false
		get_tree().paused = false
		
	# if not in PDZ
	if !in_PDZ:
		visible = false
		# get_tree().paused = false

# loads dialogue and animates the dialogue box
func load_dialogue():
	# match quest states
	# might want to move this to wizard aka parent node
	match state:
		QUEST_STATE.NOT_STARTED:
			dialogue_index = 0
		QUEST_STATE.STARTED:
			dialogue_index = 1
		QUEST_STATE.FINISHED:
			dialogue_index = 2
	
	# animate the proper dialogue
	$RichTextLabel.bbcode_text = dialogue[dialogue_index]
	$RichTextLabel.percent_visible = 0
	$Tween.interpolate_property($RichTextLabel, "percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
	print(dialogue_index)
	
	# might want to move this to wizard aka parent node
	if(dialogue_index == 0): # if the player started the dialogue, the quest has been started, very simple, might want more logic later
		state = QUEST_STATE.STARTED
	
#func set_is_visible(b):
#	is_visible = b
