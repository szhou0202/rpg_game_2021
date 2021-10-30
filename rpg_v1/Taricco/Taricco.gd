extends StaticBody2D

export var ACC = 300
export var MAX_SPEED = 50
export var FRICTION = 200

var q_answered = false
var sword_found = false
var tar_go = false

onready var animatedSprite = $AnimatedSprite
onready var animationPlayer = $AnimationPlayer
onready var pdz = $NPCPlayerDetectionZone
onready var dialogue = get_tree().root.get_node("World/CanvasLayer/TariccoDialogue/DialogueBox")
onready var small = get_tree().root.get_node("World/YSort/Small")
onready var duck = get_tree().root.get_node("World/Duck")

func _ready():
	animatedSprite.animation = "Animate"
	animationPlayer.play("Animate")

# ig this isn't necessary at least for regele
func _process(delta):
	if dialogue.state == dialogue.QUEST_STATE.FINISHED:
		small.duck_visible = true
		duck.visible = true # to get rid of bug of visible and not visible

func _on_NPCPlayerDetectionZone_body_entered(body):
	animatedSprite.animation = "Outline"
	animationPlayer.play("Outline")
	dialogue.in_PDZ = true

func _on_NPCPlayerDetectionZone_body_exited(body):
	animatedSprite.animation = "Animate"
	animationPlayer.play("Animate")
	dialogue.in_PDZ = false
