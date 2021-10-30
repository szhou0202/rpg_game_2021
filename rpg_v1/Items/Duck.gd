extends StaticBody2D

# Called when the node enters the scene tree for the first time.
onready var small = get_tree().root.get_node("World/YSort/Small")

# detecting player entering the space
func _on_PlayerDetectionZone_body_entered(body):
	if body.name == "Player" && small.duck_visible: 
		visible = false
		small.duck_found = true # potion is found
		print("found duck")
		print("visibility: ",visible)
		print("small duck visibility:", small.duck_visible)

# not necessary
func _ready(): 
	if(small.duck_visible): # to avoid having the same exact variable
		visible = true
	else:
		visible = false
	
	print("duck visibility: ", visible)
