extends Node

@onready var enemies: Node2D = $"../../Enemies"
@onready var tile_map: TileMap = $"../../TileMap"

var start_pos = Vector2(-544, -32)
var end_pos = Vector2(352,-32)
var wave_num = 1

const enemy_types = {
	"BANDIT": 0
}

func _ready():
	spawn_wave()

func spawn_wave():
	if wave_num == 1:
		for x in range(4):
			enemies.spawn_enemy(enemy_types["BANDIT"],start_pos)
			await get_tree().create_timer(0.7).timeout
