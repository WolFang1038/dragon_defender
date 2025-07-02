extends TileMap
@onready var pathfinder: Node2D = $Pathfinder
@onready var debug_line: Line2D = $Pathfinder/DebugLine

func _ready():
	find_enemy_path(Vector2i(-1,4),Vector2i(12,4))

const tile_ids = {
	"CAVE": Vector2i(0,0),
	"OBSTRUCT": Vector2i(1,0),
	"DIG": Vector2i(2,0),
	"BOOST": Vector2i(3,0),
	"CLEAR": Vector2i(4,0),
	"TUNNELS": {
		"_TUNNEL": Vector2i(0,1),
		"L_TUNNEL": Vector2i(1,1),
		"U_TUNNEL": Vector2i(2,1),
		"R_TUNNEL": Vector2i(3,1),
		"D_TUNNEL": Vector2i(4,1),
		"LU_TUNNEL": Vector2i(0,2),
		"LR_TUNNEL": Vector2i(1,2),
		"DL_TUNNEL": Vector2i(2,2),
		"RU_TUNNEL": Vector2i(3,2),
		"DU_TUNNEL": Vector2i(4,2),
		"DR_TUNNEL": Vector2i(5,2),
		"LRU_TUNNEL": Vector2i(0,3),
		"DLU_TUNNEL": Vector2i(1,3),
		"DLR_TUNNEL": Vector2i(2,3),
		"DRU_TUNNEL": Vector2i(3,3),
		"DLRU_TUNNEL": Vector2i(4,3),
	}
}
func tile_to_id(tile_pos):
	return tile_pos.x + tile_pos.y * self.get_used_rect().size.x
	
func find_enemy_path(start_pos: Vector2i, end_pos: Vector2i):
	pathfinder.build_astar()
	var pixel_enemy_path = pathfinder.astar.get_point_path(tile_to_id(start_pos), tile_to_id(end_pos))
	var tiles_enemy_path = []
	for pos in pixel_enemy_path:
		tiles_enemy_path.append(local_to_map(pos))
	debug_line.show_path(pixel_enemy_path)

func clear_tile_at(x: int, y: int):
	var tile_pos = Vector2i(x, y)  
	var current_coords = get_cell_atlas_coords(0, tile_pos)
	if current_coords == tile_ids["CAVE"]:
		set_cell(0, tile_pos, 0, tile_ids["DIG"])
	elif current_coords == tile_ids["DIG"] and GameManager.gold >= 20:
		GameManager._update_gold(-20)
		var tunnel_type = find_tunnel_type(tile_pos)
		set_cell(0, tile_pos, 0, tunnel_type)
		find_enemy_path(Vector2i(-1,4),Vector2i(12,4))

func find_tunnel_type(tile_pos):
	var tunnel_type = "_TUNNEL"
	var prefix_tunnel_type = ""
	if get_cell_atlas_coords(0, Vector2i(tile_pos.x-1,tile_pos.y)) in tile_ids["TUNNELS"].values():
		prefix_tunnel_type = sort_directions(prefix_tunnel_type + "L")
		update_tunnel_type(Vector2i(tile_pos.x-1, tile_pos.y),"R")
	if get_cell_atlas_coords(0, Vector2i(tile_pos.x,tile_pos.y-1)) in tile_ids["TUNNELS"].values():
		prefix_tunnel_type = sort_directions(prefix_tunnel_type + "U")
		update_tunnel_type(Vector2i(tile_pos.x, tile_pos.y-1),"D")
	if get_cell_atlas_coords(0, Vector2i(tile_pos.x+1,tile_pos.y)) in tile_ids["TUNNELS"].values():
		prefix_tunnel_type = sort_directions(prefix_tunnel_type + "R")
		update_tunnel_type(Vector2i(tile_pos.x+1, tile_pos.y),"L")
	if get_cell_atlas_coords(0, Vector2i(tile_pos.x,tile_pos.y+1)) in tile_ids["TUNNELS"].values():
		prefix_tunnel_type = sort_directions(prefix_tunnel_type + "D")
		update_tunnel_type(Vector2i(tile_pos.x, tile_pos.y+1),"U")
	tunnel_type = prefix_tunnel_type + tunnel_type
	return tile_ids["TUNNELS"][tunnel_type]

func update_tunnel_type(tile_pos: Vector2i,new_direction: String):
	var current_atlas = get_cell_atlas_coords(0, tile_pos)
	var current_key = get_tile_key_from_coords(current_atlas)
	if current_key == "UNKNOWN":
		return
	var directions = current_key.split("_")[0]
	directions += new_direction
	directions = sort_directions(directions)
	var new_key = directions + "_TUNNEL"
	if tile_ids["TUNNELS"].has(new_key):
		set_cell(0, tile_pos, 0, tile_ids["TUNNELS"][new_key])

func sort_directions(directions: String):
	var letters = []
	for x in directions:
		letters.append(x)
	letters.sort()  
	return "".join(letters)

func get_tile_key_from_coords(coords: Vector2i):
	for key in tile_ids["TUNNELS"]:
		if tile_ids["TUNNELS"][key] == coords:
			return key
	return "UNKNOWN"


func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var tile_coords = local_to_map(to_local(get_global_mouse_position()))
			clear_tile_at(tile_coords.x,tile_coords.y)
			for pos in get_used_cells(0):
				var atlas_coords = get_cell_atlas_coords(0,pos)
				if atlas_coords == Vector2i(2,0) and pos != tile_coords:
					set_cell(0,pos, 0, tile_ids["CAVE"])
