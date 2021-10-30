extends Control

# preloading the scene to instance later
var inv_slot = preload("res://Inventory/Templates/Inv1.tscn")
var inv_data = {}

# where we will instantiate the scene
onready var container = $Background/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
onready var wizard = get_tree().root.get_node("World/YSort/Wizard")
onready var taricco = get_tree().root.get_node("World/YSort/Taricco")
onready var regele = get_tree().root.get_node("World/YSort/Regele")
onready var wildfong = get_tree().root.get_node("World/YSort/Wildfong")
onready var ellis = get_tree().root.get_node("World/YSort/Ellis")
onready var small = get_tree().root.get_node("World/YSort/Small")

# ready, loads in inventory data
func _on_World_game_loaded():
	visible = false
	for i in inv_data.keys(): 
		if inv_data[i]:
			var new_inv_slot = inv_slot.instance()
			var name = i
			var texture = load("res://Items/"+name+".png")
			new_inv_slot.get_node("Icon").set_texture(texture)
			new_inv_slot.get_node("Label").text = name
			container.add_child(new_inv_slot, true)

# func to load a new inventory slot
func load_inv_slot(name):
	inv_data[name] = true
	var new_inv_slot = inv_slot.instance()
	var texture = load("res://Items/"+name+".png")
	new_inv_slot.get_node("Icon").set_texture(texture)
	new_inv_slot.get_node("Label").text = name
	container.add_child(new_inv_slot, true)

# func to remove an inventory slot
func remove_inv_slot(name):
	inv_data[name] = false
	
	pass

# process for inventory
func _process(delta):
	# if wizard.potion_found && !inv_data.has('potion'):
		# inv_data['potion'] = true
		# var new_inv_slot = inv_slot.instance()
		# var name = 'potion'
		# var texture = load("res://Items/"+name+".png")
		# new_inv_slot.get_node("Icon").set_texture(texture)
		# new_inv_slot.get_node("Label").text = name
		# container.add_child(new_inv_slot, true)
		
	if wildfong.wil_go && !inv_data.has('Bowl'):
		load_inv_slot("Bowl")
		
	if ellis.ellis_go && !inv_data.has('Lo Mein'):
		load_inv_slot("Lo Mein")
		
	if ellis.ellis_go && !inv_data.has('Photobook'):
		load_inv_slot("Photobook")
	
	if taricco.tar_go && !inv_data.has('Walden Audio'):
		load_inv_slot("Walden Audio")
	
	if small.duck_visible && !inv_data.has("Audio Player"):
		load_inv_slot("Audio Player")
	
	if Input.is_action_just_pressed("inventory"): 
		visible = true
	
	if Input.is_action_just_pressed("ui_cancel"):
		visible = false
