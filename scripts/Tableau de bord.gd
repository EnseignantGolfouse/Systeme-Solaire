extends HBoxContainer

signal start_pressed
signal speed_changed
signal date_changed

func _on_StartButton_pressed():
	self.emit_signal("start_pressed")

func _on_SpeedSlider_value_changed(value: float):
	self.emit_signal("speed_changed", int(value))

func _on_Date_text_entered(new_text: String) -> void:
	self.emit_signal("date_changed", new_text)
