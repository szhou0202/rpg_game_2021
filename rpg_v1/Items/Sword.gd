extends StaticBody2D

# Called when the node enters the scene tree for the first time.
onready var taricco = get_tree().root.get_node("World/YSort/Taricco")

# detecting player entering the space
func _on_PlayerDetectionZone_body_entered(body):
	if body.name == "Player":
		visible = false
		taricco.sword_found = true # potion is found
		print("found sword")

# can almost replace the ready func
func _on_World_game_loaded():
	visible = !taricco.sword_found
	print("sword: ", taricco.sword_found)
