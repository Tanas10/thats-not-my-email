extends Button


var tower: Node2D = null
var is_path = false
var cell_index: int = -1
var game 

func _ready() -> void:
	game = get_virus_defense()

func _pressed():
	var root = get_parent().get_parent().get_parent()

	if tower == null:
		root.get_node("ShopPanel").open(self)
		#$"../../../ShopPanel".open(self)
	else:
		#$"../../../UpgradePanel".open(tower,self)
		root.get_node("UpgradePanel").open(tower,self)

func set_tower(tower_scene):
	tower = tower_scene
	add_child(tower)
	tower.cell_index = cell_index
	tower.position = size / 2
	tower.add_to_group("tower")
	print(tower.position)
	if game:
		game.save_all_towers()

func get_virus_defense():
	var node = self
	while node:
		if node.has_node("VirusDefense"):
			return node.get_node("VirusDefense")
		node = node.get_parent()
	return null


func set_as_path():
	is_path = true
	modulate = Color(0.165, 0.165, 0.165, 0.0) 

func set_as_buildable():
	is_path = false
	#modulate = Color(0.4, 0.698, 0.4, 0.0)

func get_cell_index():
	return cell_index

func set_cell_index(index):
	cell_index = index
