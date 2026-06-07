class_name mainmenu
extends Control


@onready var start: Button = $MarginContainer/HBoxContainer/VBoxContainer/START as Button
@onready var settings: Button = $MarginContainer/HBoxContainer/VBoxContainer/SETTINGS as Button
@onready var exit: Button = $MarginContainer/HBoxContainer/VBoxContainer/EXIT as Button
@onready var options: optionmenu = $options as optionmenu
@onready var margin_container: MarginContainer = $MarginContainer as MarginContainer



@export var firstlevel = preload("res://SCENE/levels/level_1.tscn")




func _ready() -> void:
	handlesignal()
	
	
	
func on_button_down() -> void:
	get_tree().change_scene_to_packed(firstlevel)
	
	
func on_exit_pressed() -> void:
	get_tree().quit()
	
	
	


func handlesignal() -> void:
	start.button_down.connect(on_button_down)
	exit.button_down.connect(on_exit_pressed)
	settings.button_down.connect(on_setting_pressed)
	options.exitoption.connect(on_exit_options_menuu)
	
	
	
	
func on_setting_pressed() -> void:
	margin_container.visible =  false
	options.set_process(true )  
	options.visible = true
	
	
	
	
func on_exit_options_menuu() -> void:
	margin_container.visible = true
	options.visible= false
