extends Area2D

@onready var audio_player = $AudioStreamPlayer2D

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	print("Quelque chose entre dans la zone: ", body.name)
	audio_player.play()

func _on_body_exited(body):
	print("Quelque chose sort de la zone: ", body.name)
	audio_player.stop()
