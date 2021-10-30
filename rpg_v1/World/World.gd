# the tutorials/references I used were 
# https://www.davidepesce.com/2020/01/27/godot-tutorial-14-npc-quest-dialogue/
# https://www.youtube.com/playlist?list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a
# https://www.youtube.com/watch?v=kkLqW8WhCgg
# https://www.youtube.com/watch?v=ldKFOGRQDzo 
# https://docs.godotengine.org/en/stable/ 
# https://www.youtube.com/watch?v=lrAwX2t1mGY 

extends Node2D

export(Script) var game_save_class

signal game_loaded

onready var wizard = $YSort/Wizard
onready var wizard_dialogue_box = $CanvasLayer/WizardDialogue/DialogueBox

onready var taricco = $YSort/Taricco
onready var taricco_dialogue_box = $CanvasLayer/TariccoDialogue/DialogueBox

onready var regele = $YSort/Regele
onready var regele_dialogue_box = $CanvasLayer/RegeleDialogue/DialogueBox

onready var inv = $CanvasLayer/Inventory

func _ready():
	load_game()
	emit_signal("game_loaded")

func _process(delta):
	if Input.is_action_just_pressed("save_game"):
		save_game()

func save_game():
	var new_save = game_save_class.new() # instancing a new save
	
	new_save.wizard_dialogue_index = wizard_dialogue_box.dialogue_index
	new_save.wizard_potion_found = wizard.potion_found
	
	new_save.taricco_dialogue_index = taricco_dialogue_box.dialogue_index
	new_save.taricco_sword_found = taricco.sword_found
	
	# testing inventory 
	new_save.inventory = inv.inv_data
	
	# check if there is an existing directory or make a new one
	var dir = Directory.new()
	if !dir.dir_exists("res://saves/"):
		dir.make_dir_recursive("res://saves/")
	
	# saving resource
	ResourceSaver.save("res://saves/save_01.tres", new_save)
	
func load_game():
	# check valid file path
	var dir = Directory.new()
	if !dir.file_exists("res://saves/save_01.tres"):
		return false
	
	# setting vars from file
	var load_save = load("res://saves/save_01.tres")
	wizard.potion_found = load_save.wizard_potion_found
	taricco.sword_found = load_save.taricco_sword_found
	
	print(load_save.wizard_potion_found)
	wizard_dialogue_box.dialogue_index = load_save.wizard_dialogue_index
	print(wizard_dialogue_box.dialogue_index)
	taricco_dialogue_box.dialogue_index = load_save.taricco_dialogue_index
	
	inv.inv_data = load_save.inventory
	
	# successfully loaded
	return true
	
# verify_save is not necessary for this project
#func verify_save():
#	pass
