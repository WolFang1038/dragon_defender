extends Node

var gold = 100
var lives = 30
var gold_count = null  

func register_gold_label(label_node):
	gold_count = label_node
	_update_gold(0)  # Ensure label updates immediately

func _update_gold(gold_difference):
	gold += gold_difference
	gold_count.text = "Gold     " + str(gold)
