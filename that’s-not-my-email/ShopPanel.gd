extends Panel

var selected_cell
const FirewallScene = preload("res://Firewall.tscn")
const AntiVirusScene = preload("res://AntiVirus.tscn")


const FIREWALL_COST = 50
const ANTIVIRUS_COST = 30
const FREEZE_COST = 40

func open(cell):
	selected_cell = cell
	if selected_cell.is_path:
		return  # не дозволувај да се гради на патека
	visible = true

func _on_FirewallButton_pressed():
	buy_tower("Firewall", FIREWALL_COST)

func _on_AntivirusButton_pressed():
	buy_tower("Antivirus", ANTIVIRUS_COST)

func _on_FreezeButton_pressed():
	buy_tower("Freeze", FREEZE_COST)

func buy_tower(type, cost):
	if not GameManager.spend_money(cost):
		print("Not enough money")
		return
	
	var tower_instance
	if type == "Firewall":
		tower_instance = FirewallScene.instantiate()
	if type == "Antivirus":
		tower_instance = AntiVirusScene.instantiate()
	#print(selected_cell.cell_index)
	tower_instance.set_cell_indexT(selected_cell.cell_index)
	selected_cell.set_tower(tower_instance)
	visible = false


func _on_close_button_pressed() -> void:
	visible = false
