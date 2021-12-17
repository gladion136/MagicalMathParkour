extends Node2D

export(bool) var collect_able = true

onready var game = get_tree().current_scene

func _ready():
	$AnimationPlayer.play("idle")

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D and collect_able:
		game.add_star()
		queue_free()

func get_class():
	return "Star"
