extends TileMap

const tile_ids = {
	"CAVE": Vector2i(0,0),
	"OBSTRUCT": Vector2i(1,0),
	"DIG": Vector2i(2,0),
	"BOOST": Vector2i(0,1),
	"CLEAR": Vector2i(1,1)
}

func clear_tile_at(x: int, y: int):
	var tile_pos = Vector2i(x, y) 
	var current_coords = get_cell_atlas_coords(0, tile_pos)
	if current_coords == tile_ids["CAVE"]:
		set_cell(0, tile_pos, 0, tile_ids["DIG"])
	elif current_coords == tile_ids["DIG"] and GameManager.gold >= 20:
		GameManager._update_gold(-20)
		set_cell(0, tile_pos, 0, tile_ids["CLEAR"])


func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var tile_coords = local_to_map(to_local(get_global_mouse_position()))
			clear_tile_at(tile_coords.x,tile_coords.y)
			for pos in get_used_cells(0):
				var atlas_coords = get_cell_atlas_coords(0,pos)
				if atlas_coords == Vector2i(2,0) and pos != tile_coords:
					set_cell(0,pos, 0, tile_ids["CAVE"])
				
