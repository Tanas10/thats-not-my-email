extends Panel

var tower
var cell
var game

const DAMAGE_COST = 20
const RANGE_COST = 15
const SPEED_COST = 15

func _ready() -> void:
	game = get_virus_defense()

func open(t, c):
	tower = t
	cell = c
	visible = true

func _on_DamageBtn_pressed():
	if GameManager.spend_money(20):
		tower.upgrade_damage(5)

func _on_RangeBtn_pressed():
	if GameManager.spend_money(15):
		tower.upgrade_range(20)

func _on_SpeedBtn_pressed():
	if GameManager.spend_money(15):
		tower.upgrade_speed(0.2)

func upgrade_stat(stat, value, cost):
	if not GameManager.spend_money(cost):
		print("Not enough money")
		return

	tower[stat] += value
	tower["level"] += 1
	print(stat, " upgraded to ", tower[stat])

func _on_SellBtn_pressed():
	var refund = int(tower.cost * 0.8)
	GameManager.add_money(refund)

	cell.tower.queue_free()
	cell.tower = null
	visible = false
	if game:
		game.save_all_towers()

func _on_CloseBtn_pressed():
	visible = false
	if game:
		game.save_all_towers()


func get_virus_defense():
	var node = self
	while node:
		if node.has_node("VirusDefense"):
			return node.get_node("VirusDefense")
		node = node.get_parent()
	return null
