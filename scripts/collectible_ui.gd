extends Control

var health =75
var damage =25
func _ready() -> void:
	print("succ")
	print(eventcontrollr)
	eventcontrollr.connect("coin_collected", on_event_coin_collected)
	eventcontrollr.connect("diamond_collected",on_event_diamond_collected)
	eventcontrollr.connect("emerald_collected",on_event_emerld_collected)
	eventcontrollr.connect("damagetaken",ondamagetaken)
func on_event_coin_collected(value:int) -> void:
	$coin/Label.text = str(value) 
	print("hello")
	
func on_event_diamond_collected(value:int)-> void:
	$diamond/Label.text = str(value)

func on_event_emerld_collected(value:int) -> void :
	$TextureRect/Label2.text = str(value)
	
	
func ondamagetaken() -> void :
	$health/Label.text = str(health)
	health = health - damage
