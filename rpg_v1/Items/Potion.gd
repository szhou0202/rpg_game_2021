extends StaticBody2D

# Called when the node enters the scene tree for the first time.
onready var wizard = get_tree().root.get_node("World/YSort/Wizard")

# detecting player entering the space
func _on_PlayerDetectionZone_body_entered(body):
	if body.name == "Player":
		visible = false
		wizard.potion_found = true # potion is found
		print("found potion")

# can almost replace the ready func
func _on_World_game_loaded():
	visible = !wizard.potion_found
	print("potion: ", wizard.potion_found)
