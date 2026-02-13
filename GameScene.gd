extends Node2D

@onready var dialogue_box = $CanvasLayer/DialogueBox
@onready var player = $Player

var intro_texts: Array[String] = [
	"Une nuit comme les autres... Du moins, c'est ce que tu pensais.",
	"Au réveil, le monde n'était plus le même. Les couleurs avaient disparu, emportant avec elles la vie du village.",
	"Mais peut-être qu'au fond de cette grisaille se cache encore une étincelle... Une mélodie oubliée qui pourrait tout changer.",
	"Explore le village. Cherche ce qui résonne encore. Et surtout... écoute."
]


func _ready() -> void:
	if not player:
		print("ERREUR: Joueur introuvable !")
		return
	
	if not dialogue_box:
		print("ERREUR: DialogueBox introuvable !")
		return
	
	# Cache et désactive le joueur
	player.visible = false
	player.process_mode = Node.PROCESS_MODE_DISABLED
	
	# Connecte le signal
	dialogue_box.dialogue_finished.connect(on_intro_finished)
	
	# Lance l'intro
	await get_tree().create_timer(0.5).timeout
	dialogue_box.start_dialogues(intro_texts)
	print("Intro lancée")


func on_intro_finished() -> void:
	print("Intro terminée")
	
	# Apparition avec fondu
	player.visible = true
	player.modulate.a = 0.0
	
	var tween = create_tween()
	tween.tween_property(player, "modulate:a", 1.0, 0.5)
	await tween.finished
	
	# Réactive le joueur
	player.process_mode = Node.PROCESS_MODE_INHERIT
	print("Joueur activé !")
