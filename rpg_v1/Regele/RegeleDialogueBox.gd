extends Control

var dialogue = {
	0: 'If you can solve this simple math problem, I\'ll give you a class gift' ,
	1: 'Let x be the integers 1 to 1,000,000, inclusive, concatenated. Repeatedly compute the sum of the digits of x until it converges to a single number. What is this number?\n [A] 1       [B] 6',
	2: 'Try again.',
	3: 'Correct!! Euler would be proud. Here is a bowl. Hope you like lo mein!!'
}

# enum for quests
enum QUEST_STATE {
	NOT_STARTED,
	STARTED,
	TRY_AGAIN,
	FINISHED
}

# for wrong and right answers
const B = 2
const A = 3

var state = QUEST_STATE.NOT_STARTED
var dialogue_index = 0
var quest_finished = false # unused
var in_PDZ = false
var in_problem = false
var go = false

onready var reg = get_tree().root.get_node("World/YSort/Regele")

func _ready():
	visible = false
	
# checks if key is pressed every delta
func _process(_delta):
	# is it ready for him to go
	if reg.reg_go: 
		# gets in dialogue
		if Input.is_action_just_pressed("ui_accept") && in_PDZ:
			visible = true
			get_tree().paused = true
			load_dialogue()
			print("in prob ", in_problem)
			
		
		# gets out of dialogue
		if Input.is_action_just_pressed("ui_cancel") && in_PDZ:
			visible = false
			get_tree().paused = false
			
		
		# if correct answer and in problem, loads proper dialogue
		if Input.is_action_just_pressed("ui_a") && in_problem:
			dialogue_index = A
			state = QUEST_STATE.FINISHED
			load_dialogue()
			
		elif Input.is_action_just_pressed("ui_b") && in_problem:
			dialogue_index = B
			state = QUEST_STATE.TRY_AGAIN
			load_dialogue()
				
		
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
		QUEST_STATE.TRY_AGAIN:
			dialogue_index = B
		QUEST_STATE.FINISHED:
			dialogue_index = A
	
	# animate the proper dialogue
	if dialogue_index == 1 || dialogue_index == B:
		in_problem = true # user is in problem, animates the problem 
	else:
		in_problem = false
	
	$RichTextLabel.bbcode_text = dialogue[dialogue_index]
	$RichTextLabel.percent_visible = 0
	$Tween.interpolate_property($RichTextLabel, "percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
	# might want to move this to wizard aka parent node
	if(dialogue_index == 0): # if the player started the dialogue, the quest has been started, very simple, might want more logic later
		state = QUEST_STATE.STARTED
	
	# if try again, then display problem again
	if(dialogue_index == B):
		state = QUEST_STATE.STARTED
