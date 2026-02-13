extends Control
# Script de boîte de dialogue avec effet typewriter
# Compatible Godot 4.x

# Signaux
signal dialogue_finished
signal text_fully_displayed

# Références UI
@onready var dialogue_label: RichTextLabel = $Panel/MarginContainer/DialogueLabel
@onready var panel: Panel = $Panel

# Variables du système
var dialogues: Array[String] = []
var current_dialogue_index: int = 0
var is_text_complete: bool = false
var char_display_speed: float = 0.05  # Vitesse d'affichage (secondes par caractère)

# Variables pour l'effet typewriter
var current_text: String = ""
var displayed_chars: int = 0
var typewriter_timer: float = 0.0


func _ready() -> void:
	# Cache la boîte de dialogue au démarrage
	hide()
	
	# Configure le RichTextLabel
	if dialogue_label:
		dialogue_label.bbcode_enabled = true
		dialogue_label.visible_characters = 0


func _process(delta: float) -> void:
	# Gestion de l'effet typewriter
	if not is_text_complete and visible:
		typewriter_timer += delta
		
		if typewriter_timer >= char_display_speed:
			typewriter_timer = 0.0
			displayed_chars += 1
			
			if dialogue_label:
				dialogue_label.visible_characters = displayed_chars
				
				# Vérifie si tout le texte est affiché
				if displayed_chars >= current_text.length():
					is_text_complete = true
					text_fully_displayed.emit()


func _input(event: InputEvent) -> void:
	# Gestion de la touche Entrée
	if event.is_action_pressed("ui_accept") and visible:
		if not is_text_complete:
			# Affiche tout le texte d'un coup
			complete_text_display()
		else:
			# Passe au dialogue suivant
			next_dialogue()


# Démarre la séquence de dialogues
func start_dialogues(dialogue_list: Array[String]) -> void:
	dialogues = dialogue_list
	current_dialogue_index = 0
	show()
	display_current_dialogue()


# Affiche le dialogue actuel
func display_current_dialogue() -> void:
	if current_dialogue_index < dialogues.size():
		current_text = dialogues[current_dialogue_index]
		is_text_complete = false
		displayed_chars = 0
		typewriter_timer = 0.0
		
		if dialogue_label:
			dialogue_label.text = current_text
			dialogue_label.visible_characters = 0


# Affiche tout le texte instantanément
func complete_text_display() -> void:
	if dialogue_label:
		dialogue_label.visible_characters = -1  # Affiche tous les caractères
	is_text_complete = true
	text_fully_displayed.emit()


# Passe au dialogue suivant
func next_dialogue() -> void:
	current_dialogue_index += 1
	
	if current_dialogue_index < dialogues.size():
		# Affiche le dialogue suivant
		display_current_dialogue()
	else:
		# Tous les dialogues sont terminés
		finish_dialogues()


# Termine la séquence de dialogues
func finish_dialogues() -> void:
	hide()
	dialogue_finished.emit()


# Permet de changer la vitesse d'affichage
func set_display_speed(speed: float) -> void:
	char_display_speed = speed
