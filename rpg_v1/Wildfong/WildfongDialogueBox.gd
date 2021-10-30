extends Control

var dialogue = {
	0: 'I\'ll give you lo mein noodles if you answer this question',
	1: 'What did you do this weekend?\n    [A] Sleep        [B] STEM',
	2: 'I guess I can\'t expect much more. Here\'s your lo mein, and here\'s a photobook (I heard Mr. Ellis is looking for this)',
}

# enum for quests
enum QUEST_STATE {
	NOT_STARTED,
	STARTED,
	FINISHED
}

var state = QUEST_STATE.NOT_STARTED
var dialogue_index = 0
var quest_finished = false # unused
var in_PDZ = false

onready var wil = get_tree().root.get_node("World/YSort/Wildfong")

func _ready():
	visible = false
	
# checks if key is pressed every delta
func _process(_delta):
	
	if wil.wil_go:
		# gets in dialogue
		if Input.is_action_just_pressed("ui_accept") && in_PDZ && dialogue_index != 1: # makes sure is not currently answering question, may be error prone, should check logic later
			visible = true
			get_tree().paused = true
			load_dialogue()
		
		# logic for question
		if dialogue_index == 1 && (Input.is_action_just_pressed("ui_a") || Input.is_action_just_pressed("ui_b")):
			state = QUEST_STATE.FINISHED # finished with this quest
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

