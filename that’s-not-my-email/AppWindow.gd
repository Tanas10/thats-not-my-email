extends Panel

@onready var title_bar = $TitleBar
@onready var content = $MarginContainer/Content

var dragging := false
var drag_offset := Vector2.ZERO
var taskbar_button: Button = null
func _ready():
	title_bar.gui_input.connect(_on_title_bar_input)

func _on_title_bar_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			drag_offset = get_global_mouse_position() - global_position
			if dragging:
				get_parent().move_child(self, get_parent().get_child_count() - 1)

	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset

func set_title(text: String):
	$TitleBar/HBoxContainer/TitleLabel.text = text


func _on_close_button_pressed() -> void:
	if taskbar_button:
		taskbar_button.queue_free()
	if $TitleBar/HBoxContainer/TitleLabel.text == "VirusDefense":
		if GameManager.isWaveActive:
			GameManager.enemys_amout=0
			GameManager.waves-=1
	queue_free()
	
