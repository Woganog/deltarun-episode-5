extends Area2D

@onready var battle_cam: Camera2D = $BattleCam
@onready var collision: CollisionShape2D = $Collision
const BATTLE_UI = preload("uid://brd1dk2x0vo2b")

@onready var area_music: AudioStreamPlayer = $AreaMusic

var player = null

func _ready() -> void:
	GM.end_battle.connect(end)

func _on_body_entered(body: Node2D) -> void:
	player = body
	collision.queue_free()
	area_music.stop()
	player.camera.enabled = false
	battle_cam.enabled = true
	var battle_ui = BATTLE_UI.instantiate()
	add_child(battle_ui)

func end():
	area_music.play()
	player.camera.enabled = true
	battle_cam.enabled = false
