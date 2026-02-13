extends Node2D
# Script de gestion de l'introduction
# À attacher à une NOUVELLE scène (pas celle du joueur)

@onready var dialogue_box: Control = $CanvasLayer/DialogueBox
@onready var player: CharacterBody2D = $CharacterB  # Adapte selon le nom de ton joueur

# Textes d'introduction
var intro_dialogues: Array[String] = [
	"Une nuit comme les autres... Du moins, c'est ce que tu pensais.",
	
	"Au réveil, le monde n'était plus le même. Les couleurs avaient disparu, emportant avec elles la vie du village.",
	
	"Mais peut-être qu'au fond de cette grisaille se cache encore une étincelle... Une mélodie oubliée qui pourrait tout changer.",
	
	"Explore le village. Cherche ce qui résonne encore. Et surtout... écoute."
]


func _ready() -> void:
	# IMPORTANT : Cache et désactive le joueur au début
	if player:
		player.visible = false
		# Désactive le script du joueur temporairement
		if player.get_script():
			player.set_script_enabled(false)
	
	# Connecte le signal de fin de dialogue
	if dialogue_box:
		dialogue_box.dialogue_finished.connect(_on_intro_finished)
		
		# Démarre l'introduction après un court délai
		await get_tree().create_timer(0.5).timeout
		dialogue_box.start_dialogues(intro_dialogues)


# Appelé quand l'introduction est terminée
func _on_intro_finished() -> void:
	print("Introduction terminée - Le joueur apparaît")
	spawn_player()


func spawn_player() -> void:
	if player:
		# Rend le joueur visible
		player.visible = true
		
		# Effet de fondu optionnel
		player.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(player, "modulate:a", 1.0, 0.5)
		
		await tween.finished
		
		# Réactive le script du joueur
		if player.get_script():
			player.set_script_enabled(true)
		
		print("Le joueur peut maintenant se déplacer !")
