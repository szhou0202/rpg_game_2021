extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invinc = false setget set_invinc

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

signal invinc_started
signal invinc_ended

func set_invinc(value):
	invinc = value
	if invinc:
		emit_signal("invinc_started")
	else:
		emit_signal("invinc_ended")
	
func start_invinc(duration):
	self.invinc = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_Timer_timeout():
	self.invinc = false


func _on_HurtBox_invinc_ended():
	collisionShape.disabled = false


func _on_HurtBox_invinc_started():
	collisionShape.set_deferred("disabled",true)
