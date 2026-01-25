extends Panel

@onready var title_bar = $TitleBar
@onready var content = $MarginContainer/Content

var dragging := false
var drag_offset := Vector2.ZERO

func _ready():
	title_bar.gui_input.connect(_on_title_bar_input)

func _on_title_bar_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			drag_offset = get_global_mouse_position() - global_position

	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset

func set_title(text: String):
	$TitleBar/HBoxContainer/TitleLabel.text = text


func _on_close_button_pressed() -> void:
	queue_free()
