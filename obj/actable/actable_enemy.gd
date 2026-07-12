extends StaticBody2D

@export var sprite_visible: bool = true
@onready var sprite: Sprite2D = $Sprite
@onready var enemy: CharacterBody2D = $".."

func _ready():
	sprite.visible = sprite_visible

func acted():
	enemy.hit(4)

func hit():
	pass
