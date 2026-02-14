extends Control

var speed = 120
var path_cells: Array = []
var target_index = 1
var starthp=20
var hp = starthp
@onready var hptext = $hp


func _ready():
	add_to_group("virus")
	hp = starthp


func _process(delta):

	if path_cells.is_empty():
		return

	if target_index >= path_cells.size():
		queue_free()
		GameManager.take_dmg()
		return

	var target_cell = path_cells[target_index]
	var rect = target_cell.get_global_rect()
	var target_pos = rect.position + rect.size / 2

	var direction = (target_pos - global_position).normalized()
	global_position += direction * speed * delta
	hptext.text = str(hp)+"/"+str(starthp)

	if global_position.distance_to(target_pos) < 5:
		target_index += 1


func take_damage(amount):
	hp -= amount
	if hp <= 0:
		if GameManager.get_wave()>7:
			GameManager.add_money(50)
		GameManager.kill_enemy()
		queue_free()
