extends Label

func _ready():
	GameManager.register_lives_label(self)
