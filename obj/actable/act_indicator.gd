extends ColorRect


func _process(delta: float) -> void:
	if get_tree().paused:
		visible = true
		rotation += 1000 * delta
		
		if GM.selected == self:
			color = Color.LIGHT_GREEN
		else:
			color = Color.DARK_RED
	else:
		rotation = 0
		visible = false
		if GM.selected == self:
			GM.selected = null
			get_parent().acted()


func _on_visible_on_screen_notifier_screen_entered() -> void:
	GM.actable_array.append(self)


func _on_visible_on_screen_notifier_screen_exited() -> void:
	GM.actable_array.erase(self)
