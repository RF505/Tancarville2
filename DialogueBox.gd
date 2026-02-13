extends Control
# Système de dialogue avec effet typewriter

signal dialogue_finished

@onready var dialogue_label: RichTextLabel = $Panel/MarginContainer/DialogueLabel

var dialogues: Array[String] = []
var current_index: int = 0
var is_complete: bool = false
var speed: float = 0.04

var current_text: String = ""
var char_count: int = 0
var timer: float = 0.0


func _ready() -> void:
	hide()


func _process(delta: float) -> void:
	if not is_complete and visible:
		timer += delta
		
		if timer >= speed:
			timer = 0.0
			char_count += 1
			dialogue_label.visible_characters = char_count
			
			if char_count >= current_text.length():
				is_complete = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and visible:
		if not is_complete:
			# Affiche tout
			dialogue_label.visible_characters = -1
			is_complete = true
		else:
			# Passe au suivant
			next_dialogue()


func start_dialogues(texts: Array[String]) -> void:
	dialogues = texts
	current_index = 0
	show()
	display_current()


func display_current() -> void:
	if current_index < dialogues.size():
		current_text = dialogues[current_index]
		is_complete = false
		char_count = 0
		timer = 0.0
		dialogue_label.text = current_text
		dialogue_label.visible_characters = 0


func next_dialogue() -> void:
	current_index += 1
	if current_index < dialogues.size():
		display_current()
	else:
		hide()
		dialogue_finished.emit()
