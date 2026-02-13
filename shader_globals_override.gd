extends ShaderGlobalsOverride


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player:
		# Position du joueur en coordonnées monde
		RenderingServer.global_shader_parameter_set("player_position", player.global_position)
		
		# Animer le rayon
		current_radius = move_toward(current_radius, target_radius, delta * 100.0)
		RenderingServer.global_shader_parameter_set("color_radius", current_radius)
		
		# DEBUG
		if current_radius > 0:
			print("🔵 Rayon actuel : ", current_radius, " / Target : ", target_radius)
			print("📍 Player pos : ", player.global_position)
