extends Node2D

var damage = 10
var range = 100
var speed = 1.0
var level = 1
var cost = 0
var tower_type = ""
var timer = 0.0
var target = null
var cell_index: int = -1


func upgrade_damage(amount):
	damage += amount
	level += 1

func upgrade_range(amount):
	range += amount
	level += 1

func upgrade_speed(amount):
	speed += amount
	level += 1
func _process(delta):
	timer -= delta
	if timer <= 0:
		acquire_target()
		if target:
			shoot()
			timer = 1.0 / speed  # reset timer

func acquire_target():
	target = null
	for virus in get_tree().get_nodes_in_group("virus"):
		if global_position.distance_to(virus.global_position) <= range:
			target = virus
			break

func shoot():
	if target and target.is_inside_tree():
		if target.has_method("take_damage"):
			target.take_damage(damage)


func set_cell_indexT(index):
	cell_index = index
func get_cell_indexT():
	return cell_index
