extends Control

@onready var mail_list = $MarginContainer/MainSplit/Sidebar/ScrollContainer/MailList
@onready var sender_label = $MarginContainer/MainSplit/MailView/MarginContainer/MailContent/SenderLabel
@onready var subject_label = $MarginContainer/MainSplit/MailView/MarginContainer/MailContent/SubjectLabel
@onready var body_text = $MarginContainer/MainSplit/MailView/MarginContainer/MailContent/BodyText

@onready var end_screen = $EndScreen
@onready var score_label = $EndScreen/VBoxContainer/ScoreLabel
@onready var result_label = $EndScreen/VBoxContainer/ResultLabel


var current_mail_index := -1
var answered_mails := {}


var mails = []

func load_mails_from_json():
	var file = FileAccess.open("res://data/emails.json", FileAccess.READ)
	if file == null:
		push_error("Failed to open emails.json")
		return

	var json_text = file.get_as_text()
	file.close()

	# In Godot 4.x JSON.parse_string returns a Dictionary directly
	var json_data = JSON.parse_string(json_text)
	if json_data == null:
		push_error("Failed to parse emails.json")
		return
	mails = json_data["mails"]


func _ready():
	load_mails_from_json()
	populate_mail_list()
	show_mail(0)

func populate_mail_list():
	for i in range(mails.size()):
		var button = Button.new()
		button.text = mails[i]["subject"]
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.clip_text=true
		button.autowrap_mode=TextServer.AUTOWRAP_WORD
		button.pressed.connect(func(): show_mail(i))
		mail_list.add_child(button)


func show_mail(index: int):
	current_mail_index = index
	var mail = mails[index]
	sender_label.text = "From: " + mail["sender"]
	subject_label.text = "Subject: " + mail["subject"]
	body_text.text = mail["body"]


func _on_scam_button_pressed() -> void:
	make_decision(true)


func _on_legit_button_pressed() -> void:
	make_decision(false)


func make_decision(player_thinks_scam: bool):
	if current_mail_index == -1:
		return
	if answered_mails.has(current_mail_index):
		return 
	var mail = mails[current_mail_index]
	var correct = mail["is_scam"] == player_thinks_scam
	answered_mails[current_mail_index] = correct
	show_feedback(correct)
	lock_current_mail()
	if is_game_finished():
		end_game()

func show_feedback(correct: bool):
	var button = mail_list.get_child(current_mail_index)

	var theme = button.get_theme()
	if theme == null:
		theme = Theme.new()

	if correct:
		theme.set_color("font_disabled_color", "Button", Color("#5bd170"))
		body_text.append_text("\n\n[color=green]✔ Correct decision[/color]")
	else:
		theme.set_color("font_disabled_color", "Button", Color("#ff0000ff"))
		body_text.append_text("\n\n[color=red]✘ Wrong decision[/color]")
	button.set_theme(theme)



func lock_current_mail():
	var button = mail_list.get_child(current_mail_index)
	button.disabled = true


func is_game_finished() -> bool:
	return answered_mails.size() == mails.size()

func end_game():
	var correct_count := 0
	for result in answered_mails.values():
		if result:
			correct_count += 1
	show_end_screen(correct_count)

func show_end_screen(correct_count: int):
	end_screen.visible = true
	score_label.text = "Score: %d / %d" % [correct_count, mails.size()]
	if correct_count == mails.size():
		result_label.text = "Perfect! You spotted every scam."
	elif correct_count >= mails.size() / 2:
		result_label.text = "Not bad, but some scams slipped through."
	else:
		result_label.text = "Your inbox is compromised."





func _on_close_button_pressed() -> void:
	get_parent().queue_free()
