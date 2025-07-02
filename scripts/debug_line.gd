extends Line2D
@onready var tile_map: TileMap = $"../.."

func show_path(path):
	self.clear_points()
	for point in path:
		self.add_point(point)
