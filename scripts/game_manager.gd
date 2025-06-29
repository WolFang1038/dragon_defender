extends Node

var gold = 200
var lives = 30
var gold_count = null  
var lives_count = null

func register_gold_label(label_node):
	gold_count = label_node
	_update_gold(0)  # Ensure label updates immediately

func _update_gold(gold_difference: int):
	gold += gold_difference
	gold_count.text = "Gold     " + str(gold)

func register_lives_label(label_node):
	lives_count = label_node
	_update_lives(0)  # Ensure label updates immediately

func _update_lives(lives_difference: int):
	lives += lives_difference
	lives_count.text = "lives    " + str(lives)
