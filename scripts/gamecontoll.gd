extends Node


var totalcoins = 0
var totadiamond = 0
var totalemerld = 0
func coincollected(value:int):
	totalcoins = totalcoins + value
	print("emitting coin_collected with: ", totalcoins)
	eventcontrollr.emit_signal("coin_collected", totalcoins)


func diamondcollected(value: int):
	totadiamond = totadiamond + value
	eventcontrollr.emit_signal("diamond_collected", totadiamond)  

func emerldcollected(value:int):
	totalemerld = totalemerld + value
	eventcontrollr.emit_signal("emerald_collected", totalemerld)
