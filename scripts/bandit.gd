extends Area2D

var path: Array[Vector2] = []
var current_path_index = 0
@export var speed = 50.0

func set_path(new_path: Array[Vector2]):
	path = new_path
	current_path_index = 0
	if path.size() > 0:
		global_position = path[0]

func _process(delta):
	if current_path_index >= path.size():
		return
	
	var target = path[current_path_index]
	var direction = (target - global_position).normalized()
	var distance = speed * delta
	
	if global_position.distance_to(target) <= distance:
		current_path_index += 1
	else:
		global_position += direction * delta

func die():
	queue_free()
