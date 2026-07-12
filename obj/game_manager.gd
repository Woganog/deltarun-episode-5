extends Node

var selected = null
var actable_array: Array

var player_hp: int = 200
var player_max_hp: int = 200

signal end_battle

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
