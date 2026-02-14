extends Control

@onready var grid = $VBoxContainer/GridContainer
const CellScene = preload("res://CellButton.tscn")
const VirusScene = preload("res://Virus.tscn")


var columns = 20
var rows = 10
var current_wave = GameManager.get_wave()
var path: Array = []
var path_cells: Array = []
var amount = 0
var current_enemys = 0

func _ready():
	GameManager.money_changed.connect(update_money)
	update_money(GameManager.money)

	generate_grid()
	await get_tree().process_frame
	generate_snake_path()
	load_saved_towers()
	add_datacentar()




func _process(delta):
	current_enemys = GameManager.get_enemys()
	$VBoxContainer/HBoxContainer/Wave.text = "Wave:" + str(current_wave)
	$VBoxContainer/HBoxContainer/Enemys.text = "Enemys:" + str(GameManager.enemys_amout)
	$VBoxContainer/HBoxContainer/Lives.text = "Lives:" + str(GameManager.lives)
	GameOver()
	if current_enemys == 0:
		GameManager.set_isWaveActive(false)

func update_money(amount):
	$VBoxContainer/HBoxContainer/MoneyLabel.text = "Money: " + str(amount)

func generate_grid():
	for child in grid.get_children():
		child.queue_free()

	for i in range(columns * rows):
		var cell = CellScene.instantiate()
		cell.name=str(i)
		cell.set_cell_index(i)
		grid.add_child(cell)


func get_virus_path() -> Array:
	var result = []
	await get_tree().process_frame

	var cells = grid.get_children()
	var middle_row = int(rows / 2)

	for col in range(columns):
		var index = middle_row * columns + col
		result.append(cells[index]) 

	return result


func spawn_virus():
	var virus = VirusScene.instantiate()
	
	if current_wave >=5 and current_wave<10:
		virus.speed +=50
		virus.starthp +=5
	if current_wave>=10:
		virus.speed +=50
		virus.starthp +=10
	
	add_child(virus)

	virus.path_cells = path_cells
	virus.global_position = get_cell_center(path_cells[0])


func get_cell_center(cell):
	var rect = cell.get_global_rect()
	return rect.position + rect.size / 2



func generate_snake_path():
	path_cells.clear()

	var cells = grid.get_children()

	for r in range(0, rows, 2): 

		var left_to_right = (r / 2) % 2 == 0

		if left_to_right:

			for c in range(columns):
				var index = r * columns + c
				var cell = cells[index]
				cell.set_as_path()
				path_cells.append(cell)

			if r + 2 < rows:
				var down_index = (r + 1) * columns + (columns - 1)
				var down_cell = cells[down_index]
				down_cell.set_as_path()
				path_cells.append(down_cell)

		else:
			for c in range(columns - 1, -1, -1):
				var index = r * columns + c
				var cell = cells[index]
				cell.set_as_path()
				path_cells.append(cell)
				
			if r + 2 < rows:
				var down_index = (r + 1) * columns
				var down_cell = cells[down_index]
				down_cell.set_as_path()
				path_cells.append(down_cell)
	 
	for i in range(cells.size()):
		if not cells[i].is_path:
			cells[i].set_as_buildable()
	

func _on_button_pressed() -> void:
	if current_enemys<=0:
		start_wave()

func start_wave():
	
	current_wave += 1
	GameManager.set_wave(current_wave)
	GameManager.set_isWaveActive(true)
	amount = 3 + current_wave * 2
	GameManager.change_enemys(amount)
	GameManager.answaredmails = 0
	for i in range(amount):
		spawn_virus()
		await get_tree().create_timer(0.6).timeout

func add_datacentar():
	var cells = grid.get_children()
	cells[179].modulate =  Color(1.0, 1.0, 1.0, 1.0) 
	cells[179].icon =  preload("res://icons/VirusDefense.png")
	cells[179].flat =true

func save_all_towers():
	var towers = []
	for t in get_tree().get_nodes_in_group("tower"):
		towers.append(t)
	GameManager.save_towers_in_memory(towers)


func load_saved_towers():
	var saved_towers = GameManager.load_towers_from_memory()
	var cells = grid.get_children()
	
	for t_data in saved_towers:
		var tower_scene
		match t_data["type"]:
			"Firewall":
				tower_scene = preload("res://Firewall.tscn")
			"AntiVirus":
				tower_scene = preload("res://Antivirus.tscn")

		if tower_scene:
			var tower = tower_scene.instantiate()

			tower.cell_index = t_data["cell_index"]
			tower.tower_type = t_data["type"]
			tower.level = t_data["level"]
			tower.damage = t_data["damage"]
			tower.range = t_data["range"]
			tower.speed = t_data["speed"]
			tower.position = t_data["position"]
			grid.get_child(tower.cell_index).add_child(tower)
			var cell = cells[tower.cell_index]
			cell.tower = tower
			tower.add_to_group("tower")


func GameOver():
	if GameManager.lives <=0:
		current_enemys=30
		$GameOverPanel.visible=true

func _on_restart_pressed() -> void:
	$GameOverPanel.visible=false
	current_wave=0
	GameManager.lives=10
	GameManager.enemys_amout=0
	GameManager.isWaveActive=false
	GameManager.set_money(150)
	GameManager.set_wave(0)
