extends CanvasLayer

var selected = 0


func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_openmenu"):
		get_tree().paused = true
		visible = true
		
		if Input.is_action_just_pressed("m_left"):
			selected = clamp(selected - 1, 0, GM.actable_array.size() - 1)
			GM.selected = GM.actable_array[selected]
		if Input.is_action_just_pressed("m_right"):
			selected = clamp(selected + 1, 0, GM.actable_array.size() - 1)
			GM.selected = GM.actable_array[selected]
		if Input.is_action_just_pressed("m_down"):
			selected = clamp(selected - 1, 0, GM.actable_array.size() - 1)
			GM.selected = GM.actable_array[selected]
		if Input.is_action_just_pressed("m_up"):
			selected = clamp(selected + 1, 0, GM.actable_array.size() - 1)
			GM.selected = GM.actable_array[selected]
	else:
		get_tree().paused = false
		visible = false
