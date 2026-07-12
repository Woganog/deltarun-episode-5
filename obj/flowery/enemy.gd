extends CharacterBody2D


const SPEED = 2000.0
var hp: int = 12
var max_hp: int = 12

var dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
@onready var hp_label: Label = $HPLabel

func _physics_process(delta: float) -> void:
	velocity = dir * SPEED * delta
	
	if is_on_wall() or is_on_floor() or is_on_ceiling():
		dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	move_and_slide()
	
	hp_label.text = "hp: " + str(hp) + "/" + str(max_hp)

func hit(damage = 1):
	hp -= damage
	pulse()
	if hp <= 0:
		GM.end_battle.emit()
		queue_free()

func pulse():
	modulate.a = 0.5
	await get_tree().create_timer(0.1).timeout
	modulate.a = 1.0


func _on_hitbox_body_entered(body: Node2D) -> void:
	body.hit()
