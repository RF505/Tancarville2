extends Area2D

func _ready():
	# Cacher les labels au départ
	$Label.visible = false
	$Label2.visible = false
	$Sprite2D.visible = false
	# Connecter le signal de collision
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Vérifier si c'est le Player qui entre en collision
	if body.name == "Player":
		# Afficher le texte (choisissez Label ou Label2)
		$Label.visible = true
		
		# Attendre 3 secondes
		await get_tree().create_timer(1.5).timeout
		
		$Label2.visible = true
		await get_tree().create_timer(0.6).timeout
		$Sprite2D.visible = true
		$Sprite2D/AnimationPlayer.play("default")
		await get_tree().create_timer(0.44).timeout
		
		# Changer vers la scène des crédits
		get_tree().change_scene_to_file("res://credits.tscn")
