extends StaticBody2D

func _ready():
	# Connecter les signaux
	$Area2D.body_entered.connect(_on_player_entered)
	$Area2D.body_exited.connect(_on_player_exited)
	# Rendre platform2 invisible
	$platform2.modulate.a = 0.0

func _on_player_entered(body):
	print("👤 Body entré : ", body.name)
	if body.name == "Player":
		print("✅✅✅ PLAYER DÉTECTÉ SUR PLATFORM !")
		body.sur_platform = true
		print("sur_platform mis à : ", body.sur_platform)

func _on_player_exited(body):
	print("👤 Body sorti : ", body.name)
	if body.name == "Player":
		print("❌❌❌ PLAYER QUITTE PLATFORM !")
		body.sur_platform = false
