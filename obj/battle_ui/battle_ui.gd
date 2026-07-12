extends CanvasLayer

@onready var hp_label: RichTextLabel = $HPLabel

func _ready() -> void:
	GM.end_battle.connect(end)

func _process(delta: float) -> void:
	hp_label.text = "gris hp: " + str(GM.player_hp) + " / " + str(GM.player_max_hp)

func end():
	queue_free()
