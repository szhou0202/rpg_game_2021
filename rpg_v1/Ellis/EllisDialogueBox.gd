extends Control

var dialogue = {
	0: 'Do you know where my precious photobook went? I can\'t allow my high school pictures be leaked to the world!!',
	1: 'You have my photobook? Thank goodness!!',
	2: 'Thank you for getting my photobook back to me. In exchange, here\'s an audiobook of Walden. By the way, you might want to ask Mrs. Taricco about an audio player.',
}

# enum for quests, really only keeping track of when ellis gives the user an audiobook and when ellis takes his own photobook
enum QUEST_STATE {
	NOT_STARTED,
	STARTED,
	FINISHED
}

var state = QUEST_STATE.NOT_STARTED
var dialogue_index = 0
var quest_finished = false # unused, perhaps use in future to give ellis the book
var in_PDZ = false

onready var ellis = get_tree().root.get_node("World/YSort/Ellis")

func _ready():
	visible = false
	
# checks if key is pressed every delta
func _process(_delta):
	if ellis.ellis_go:
		# gets in dialogue
		if Input.is_action_just_pressed("ui_accept") && in_PDZ: # makes sure is not currently answering question, may be error prone, should check logic later
			visible = true
			get_tree().paused = true
			load_dialogue()
		
		# gets out of dialogue
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
	match state:
		# is this redundant?
		QUEST_STATE.NOT_STARTED:
			dialogue_index = 0
		QUEST_STATE.STARTED:
			dialogue_index = 1
		QUEST_STATE.FINISHED:
			dialogue_index = 2
	
	$RichTextLabel.bbcode_text = dialogue[dialogue_index]
	$RichTextLabel.percent_visible = 0
	$Tween.interpolate_property($RichTextLabel, "percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
	# might want to move this to wizard aka parent node
	if(dialogue_index == 0): # if the player started the dialogue, the quest has been started, very simple, might want more logic later
		state = QUEST_STATE.STARTED
	
	# just advancing through the dialogue
	if(dialogue_index == 1):
		state = QUEST_STATE.FINISHED

