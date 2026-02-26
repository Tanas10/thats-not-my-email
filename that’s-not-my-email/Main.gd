extends Control

@onready var window_layer = $Desktop/WindowLayer
@onready var mail_text = $Desktop/DesktopIcons/MailIcon.text
@onready var notepad_text = $Desktop/DesktopIcons2/NotepadIcon.text
@onready var notepad_text1 = $Desktop/DesktopIcons2/NotepadIcon2.text
@onready var notepad_text2 = $Desktop/DesktopIcons2/NotepadIcon3.text
@onready var notepad_text3 = $Desktop/DesktopIcons2/NotepadIcon4.text
@onready var virus_defense_text = $Desktop/DesktopIcons/VirusDefense.text
@onready var start_menu_panel=$Desktop/StartMenuPanel



@onready var taskbar= $Desktop/Taskbar/HBoxContainer

var app_window_scene = preload("res://AppWindow.tscn")
var mail_app_scene = preload("res://MailApp.tscn")
var notepad_app_scene = preload("res://NotepadApp.tscn")
var virus_defense_scene =preload("res://VirusDefense.tscn")


const PopUpScene = preload("res://PopUpNotification.tscn")
var wave = 0
var isWaveActive = false
var popup_shown = false
var current_enemys =0

var isStartMenuActive = false

func _process(delta):
	current_enemys = GameManager.get_enemys()
	wave = GameManager.get_wave()
	isWaveActive = GameManager.get_isWaveActive()
	if current_enemys == 0 and wave!=0 and isWaveActive and not popup_shown:
		popup_shown = true
		show_mail_popup()


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
	var button = Button.new()
	button.text = title
	var theme = button.get_theme()
	if theme == null:
		theme = Theme.new()
	theme.set_color("font_color", "Button", Color("000000ff"))
	button.set_theme(theme)
	button.add_theme_stylebox_override("normal", preload("res://startbuttonlook.tres"))
	taskbar.add_child(button)

	button.pressed.connect(func():
		window.get_parent().move_child(window, window.get_parent().get_child_count() - 1) 
		window.show() )
	
	window.taskbar_button = button
	window.connect("tree_exited", Callable(self, "_on_window_closed"))
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
	
func _on_window_closed(window_node):
	if window_node.has_method("taskbar_button") and window_node.taskbar_button:
		window_node.taskbar_button.queue_free()


func _on_virus_defense_pressed() -> void:
	open_app(virus_defense_scene, virus_defense_text)

func show_mail_popup():
	if GameManager.get_wave()<=6:
		var popup = PopUpScene.instantiate()
		add_child(popup)
		await get_tree().create_timer(5).timeout
		popup_shown=false
		remove_child(popup)


func _on_startbutton_pressed() -> void:
	if isStartMenuActive:
		start_menu_panel.visible=false
		isStartMenuActive = !isStartMenuActive
	else:
		start_menu_panel.visible=true
		isStartMenuActive = !isStartMenuActive


func _on_quit_button_pressed() -> void:
	get_tree().quit()
