extends StaticBody2D

func _ready():
	# Vérifier l'Area2D
	if has_node("Area2D"):
		$Area2D.body_entered.connect(_on_player_entered)
		$Area2D.body_exited.connect(_on_player_exited)
	else:
		print("ERREUR : Area2D introuvable !")
	
	# Mettre platform2 invisible au départ
	if has_node("platform2"):
		$platform2.modulate.a = 0.0
		print("platform2 trouvé et mis invisible")
	else:
		print("ERREUR : platform2 introuvable !")

func _on_player_entered(body):
	print("Quelque chose entre : ", body.name)
	if body.name == "Player":
		print("Player est sur platform !")
		body.sur_platform = true

func _on_player_exited(body):
	print("Quelque chose sort : ", body.name)
	if body.name == "Player":
		print("Player quitte platform !")
		body.sur_platform = false
