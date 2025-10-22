extends Node2D

@export var enemy_scenes: Array[PackedScene] = []

@onready var tile_map: TileMap = $"../TileMap"
@onready var wave_manager: Node = $"../GameController/WaveManager"
var path: Array[Vector2] = []

func set_path(new_path: Array[Vector2]):
	path = new_path
	
func spawn_enemy(enemy_index: int, start_pos: Vector2):
	if enemy_index < 0 or enemy_index >= enemy_scenes.size():
		return null
	
	var end_tile = Vector2i(tile_map.local_to_map(tile_map.to_local(wave_manager.end_pos)).x,tile_map.local_to_map(tile_map.to_local(wave_manager.end_pos)).y)
	var enemy = enemy_scenes[enemy_index].instantiate()
	add_child(enemy)
	enemy.global_position = start_pos
	enemy.tile = Vector2i(tile_map.local_to_map(tile_map.to_local(start_pos)).x,tile_map.local_to_map(tile_map.to_local(start_pos)).y)
	path = tile_map.find_enemy_path(enemy.tile,end_tile)
	enemy.set_path(path)

func clear_enemies():
	for enemy in get_children():
		enemy.queue_free()
