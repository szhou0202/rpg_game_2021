extends StaticBody2D

export var ACC = 300
export var MAX_SPEED = 50
export var FRICTION = 200

var q_answered = false
var reg_go = false

onready var animatedSprite = $AnimatedSprite
onready var animationPlayer = $AnimationPlayer
onready var pdz = $NPCPlayerDetectionZone
onready var dialogue = get_tree().root.get_node("World/CanvasLayer/RegeleDialogue/DialogueBox")
onready var wil = get_tree().root.get_node("World/YSort/Wildfong")

func _ready():
	animatedSprite.animation = "Animate"
	animationPlayer.play("Animate")

func _process(delta):
	if dialogue.state == dialogue.QUEST_STATE.FINISHED:
		wil.wil_go = true

func _on_NPCPlayerDetectionZone_body_entered(body):
	animatedSprite.animation = "Outline"
	animationPlayer.play("Outline")
	dialogue.in_PDZ = true

func _on_NPCPlayerDetectionZone_body_exited(body):
	animatedSprite.animation = "Animate"
	animationPlayer.play("Animate")
	dialogue.in_PDZ = false
