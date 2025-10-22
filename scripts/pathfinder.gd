extends Node2D

var astar = AStar2D.new()
@onready var tilemap: TileMap = $".."

func _ready():
	build_astar()

func tile_to_id(tile_pos):
	var used_rect := tilemap.get_used_rect()
	var offset_pos = tile_pos - used_rect.position  # shift all tiles to positive space
	return offset_pos.x + offset_pos.y * used_rect.size.x

func build_astar():
	var tunnels = tilemap.tile_ids["TUNNELS"].values()  #Finds all the tunnels values
	
	for pos in tilemap.get_used_cells(0):   #Checks every used tile, finds all tunnels and adds them to astar
		var atlas = tilemap.get_cell_atlas_coords(0,pos)
		if atlas in tunnels:
			var id = tile_to_id(pos)
			astar.add_point(id, tilemap.map_to_local(pos))

# Add connections between neighboring tunnel tiles
	for pos in tilemap.get_used_cells(0):              
		var atlas = tilemap.get_cell_atlas_coords(0, pos) 
		if atlas in tunnels:                              
			var current_id = tile_to_id(pos)                
			for offset in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:  
				var neighbour = pos + offset              
				if tilemap.get_cell_atlas_coords(0, neighbour) in tunnels:  
					var neighbour_id = tile_to_id(neighbour)    
					if not astar.has_point(neighbour_id): continue 
					astar.connect_points(current_id, neighbour_id) 
