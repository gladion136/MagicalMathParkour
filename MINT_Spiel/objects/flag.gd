extends Node2D

onready var game = get_tree().current_scene

func _ready():
	$AnimationPlayer.play("idle")


func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		game.game_finished()
