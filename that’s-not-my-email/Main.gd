extends Control

@onready var window_layer = $Desktop/WindowLayer
@onready var mail_text = $Desktop/DesktopIcons/MailIcon.text
@onready var notepad_text = $Desktop/DesktopIcons/NotepadIcon.text
@onready var notepad_text1 = $Desktop/DesktopIcons/NotepadIcon2.text
@onready var notepad_text2 = $Desktop/DesktopIcons/NotepadIcon3.text
@onready var notepad_text3 = $Desktop/DesktopIcons/NotepadIcon4.text


var app_window_scene = preload("res://AppWindow.tscn")
var mail_app_scene = preload("res://MailApp.tscn")
var notepad_app_scene = preload("res://NotepadApp.tscn")
 
func open_app(app_scene: PackedScene, title: String) -> Node:
	var window = app_window_scene.instantiate()
	var app = app_scene.instantiate()
	window.set_title(title)
	window_layer.add_child(window)
	window.content.add_child(app)

	var screen_size = get_viewport_rect().size
	window.global_position = screen_size / 2 - window.size / 2

	window.anchor_left = 0.1
	window.anchor_top = 0.1
	window.anchor_right = 0.9
	window.anchor_bottom = 0.9
	window.offset_left = 0
	window.offset_top = 0
	window.offset_right = 0
	window.offset_bottom = 0

	return app


func _on_mail_icon_pressed() -> void:
	open_app(mail_app_scene, mail_text)


func _on_notepad_icon_pressed() -> void:
	var index := 0  
	var app = open_app(notepad_app_scene, notepad_text)
	app.show_note(index)


func _on_notepad_icon_2_pressed() -> void:
	var index := 1 
	var app = open_app(notepad_app_scene, notepad_text1)
	app.show_note(index)


func _on_notepad_icon_3_pressed() -> void:
	var index := 2
	var app = open_app(notepad_app_scene, notepad_text2)
	app.show_note(index)


func _on_notepad_icon_4_pressed() -> void:
	var index := 3
	var app = open_app(notepad_app_scene, notepad_text3)
	app.show_note(index)
