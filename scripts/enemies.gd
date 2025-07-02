extends Node2D

@export var enemy_scenes: Array[PackedScene] = []
var path: Array[Vector2] = []

func set_path(new_path: Array[Vector2]):
	path = new_path
	
func spawn_enemy(enemy_index: int, start_position: Vector2):
	if enemy_index < 0 or enemy_index >= enemy_scenes.size():
		return null
	
	var enemy = enemy_scenes[enemy_index].instantiate()
	add_child(enemy)
	enemy.global_position = start_position
	
	if enemy.has_method("set_path"):
		enemy.set_path(path)

func clear_enemies():
	for enemy in get_children():
		enemy.queue_free()
