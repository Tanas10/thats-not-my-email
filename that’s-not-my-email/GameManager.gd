extends Node

var money = 50
var enemys_amout = 0
var waves = 0
var isWaveActive = false
var lives = 10
var answaredmails=0
signal money_changed(new_amount)

func change_enemys(amount_enemy):
	enemys_amout = amount_enemy
func kill_enemy():
	enemys_amout-=1
func take_dmg():
	enemys_amout-=1
	lives-=1
func get_enemys():
	return enemys_amout

func get_wave():
	return waves
func set_isWaveActive(isWavesActive):
	isWaveActive=isWavesActive

func get_isWaveActive():
	return isWaveActive
func set_wave(wave):
	waves=wave

func add_money(amount):
	money += amount
	emit_signal("money_changed", money)

func can_afford(cost) -> bool:
	return money >= cost

func spend_money(cost) -> bool:
	if money < cost:
		return false
	money -= cost
	emit_signal("money_changed", money)
	return true
	

func set_money(money1):
	money=money1



var saved_towers: Array = []

func save_towers_in_memory(towers: Array) -> void:
	saved_towers.clear()
	for t in towers:
		saved_towers.append({
			"cell_index": t.cell_index,
			"type": t.tower_type,
			"level": t.level,
			"damage": t.damage,
			"range": t.range,
			"speed": t.speed,
			"position": t.position
		})
		print(t)
func load_towers_from_memory() -> Array:
	return saved_towers.duplicate()  
