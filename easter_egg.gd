extends Area2D

func _ready():
	# Connecter le signal de collision
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Vérifier si c'est le Player
	if body.name == "Player":
		# Changer directement vers la scène TANCARVILLE
		get_tree().change_scene_to_file("res://TANCARVILLE.tscn")
