extends Area2D


func _on_body_exited(body: Node2D) -> void:
	body.dir = -body.dir
