extends Control

@onready var notepad_text = $MarginContainer/NotepadText

var note =[]
func _ready():
	load_note()


func load_note():
	var file := FileAccess.open("res://data/notepads.json", FileAccess.READ)
	if file == null:
		push_error("Failed to open notes.json")
		return
	var json_text := file.get_as_text()
	file.close()
	var json := JSON.new()
	var err := json.parse(json_text)
	if err != OK:
		push_error("Failed to parse clues.json: %s" % json.get_error_message())
		return
	var json_data: Dictionary = json.data
	note = json_data["notes"]




func show_note(index: int):
	notepad_text.text = note[index]["text"]
