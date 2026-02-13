extends Control

signal dialogue_finished

@onready var dialogue_label: RichTextLabel = $Panel/MarginContainer/DialogueLabel

@export var speed: float = 0.04 
var dialogues: Array[String] = []
var current_index: int = 0
var tween: Tween
var is_typing: bool = false

func _ready() -> void:
	hide()
	# On s'assure que le texte ne dépasse pas du conteneur
	dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD

func start_dialogues(texts: Array[String]) -> void:
	dialogues = texts
	current_index = 0
	show()
	display_current()

func display_current() -> void:
	if current_index < dialogues.size():
		is_typing = true
		dialogue_label.text = dialogues[current_index]
		dialogue_label.visible_characters = 0
		
		# Animation des lettres
		if tween: tween.kill() # On arrête l'ancien tween s'il existe
		tween = create_tween()
		
		var duration = dialogue_label.text.length() * speed
		tween.tween_property(dialogue_label, "visible_characters", dialogue_label.text.length(), duration)
		tween.finished.connect(func(): is_typing = false)
	else:
		_finish_all()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and visible:
		if is_typing:
			# ON PASSE L'ANIMATION : on affiche tout
			if tween: tween.kill()
			dialogue_label.visible_characters = -1
			is_typing = false
		else:
			# ON PASSE À LA SUITE
			next_dialogue()

func next_dialogue() -> void:
	current_index += 1
	display_current()

func _finish_all() -> void:
	hide()
	dialogue_finished.emit()
