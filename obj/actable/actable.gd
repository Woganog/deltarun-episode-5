extends StaticBody2D

@export var sprite_visible: bool = true
@onready var sprite: Sprite2D = $Sprite

func _ready():
	sprite.visible = sprite_visible

func acted():
	queue_free()

func hit():
	queue_free()
