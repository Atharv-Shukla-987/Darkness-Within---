class_name optionmenu

extends Control

@onready var exitbutton: Button = $MarginContainer/VBoxContainer/Button as Button

signal exitoption 



func _ready() -> void:
	exitbutton.button_down.connect(on_pressed)
	set_process(false)
	
func on_pressed() -> void:
	exitoption.emit()
	set_process(false)
