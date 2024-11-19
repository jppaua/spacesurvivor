extends Node
var pixelFont = preload("res://assets/fonts/Hardpixel-nn51.otf")

func display_number(value: int, position: Vector2):
	var number = Label.new()
	number.global_position = position
	number.text = str(value)
	number.z_index = 999
	number.label_settings = LabelSettings.new()
	
	var color = "#FFF"
	
	number.label_settings.font_color = color
	number.label_settings.font_color = color
	number.label_settings.font_size = 20
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 10
	number.add_theme_font_override("font", pixelFont)
	
	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(number, "position:y", number.position.y - 24, 0.25).set_ease(tween.EASE_OUT)
	tween.tween_property(number, "position:y", number.position.y, 0.5).set_ease(tween.EASE_IN).set_delay(0.25)
	tween.tween_property(number, "scale", Vector2.ZERO, 0.25).set_ease(tween.EASE_IN).set_delay(0.25)
	await tween.finished
	number.queue_free()
	
