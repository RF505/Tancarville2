extends Area2D

@onready var music = $AudioStreamPlayer2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		music.play()

func _on_body_exited(body):
	if body.is_in_group("player"):
		music.stop()
