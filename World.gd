extends Node2D

onready var rooms_texture_data = preload("res://rooms.png").get_data()
var tilemap = null

const ROOM_SIZE = 8
const ROOM_TYPES = 8
const ROOM_ROWS = 2
const WALL_SIZE = 16
const WALL_TYPES = 4

const ROOM_COUNT = 6



func _ready():
	randomize()
	tilemap = $TileMap
	gen_map()
		
func gen_map():
	var map = {}
	var origin = [ROOM_COUNT - 3, ROOM_COUNT - 3]
	map[str(origin)] = {"type": randi() % ROOM_TYPES, "coords": origin}
	var empty_adjacenies = get_empty_adjacencies(map, origin)
	while len(map.keys()) < ROOM_COUNT:
		var empty_index = randi() % len(empty_adjacenies)
		var coords = empty_adjacenies[empty_index]
		empty_adjacenies.remove(empty_index)
		map[str(coords)] = {"type": randi() % ROOM_TYPES, "coords": coords}
		empty_adjacenies += get_empty_adjacencies(map, coords)
		
	for key in map:
		gen_room(map[key], map)
	
func get_empty_adjacencies(map, coords):
	var empties = []
	for i in 2:
		for offset in range(-1, 2, +2):
			var adj = [] + coords
			adj[i] += offset
			if not str(adj) in map:
				empties.append(adj)
	return empties
	
func gen_room(room, map):
	var coords = room["coords"]
	var offset_x = coords[0] * ROOM_SIZE
	var offset_y = coords[1] * ROOM_SIZE
	var type = room["type"]
	var room_y = (type % ROOM_ROWS) * ROOM_SIZE
	var room_x = (type / ROOM_ROWS) * ROOM_SIZE
	var wall_type
	
	for x in range(ROOM_SIZE):
		for y in range(ROOM_SIZE):
			rooms_texture_data.lock()
			var cell_data = rooms_texture_data.get_pixel(room_x + x, room_y + y)
			if cell_data == Color.black:
				wall_type = randi() % 4
				tilemap.set_cell(offset_x + x, offset_y + y, wall_type, randi() % 2 == 0, randi() % 2 == 0)
	
	var room_left = str([coords[0] - 1, coords[1]]) in map
	var room_top = str([coords[0], coords[1] - 1]) in map
	var room_right = str([coords[0] + 1, coords[1]]) in map
	var room_bottom = str([coords[0], coords[1] + 1]) in map
	
	if not room_left:
		wall_type = randi() % 4
		tilemap.set_cell(offset_x, offset_y + 3, wall_type, randi() % 2 == 0, randi() % 2 == 0)
		tilemap.set_cell(offset_x, offset_y + 4, wall_type, randi() % 2 == 0, randi() % 2 == 0)
	if not room_top:
		wall_type = randi() % 4
		tilemap.set_cell(offset_x + 3, offset_y, wall_type, randi() % 2 == 0, randi() % 2 == 0)
		tilemap.set_cell(offset_x + 4, offset_y, wall_type, randi() % 2 == 0, randi() % 2 == 0)
	if not room_right:
		wall_type = randi() % 4
		tilemap.set_cell(offset_x + ROOM_SIZE - 1, offset_y + 3, wall_type, randi() % 2 == 0, randi() % 2 == 0)
		tilemap.set_cell(offset_x + ROOM_SIZE - 1, offset_y + 4, wall_type, randi() % 2 == 0, randi() % 2 == 0)
	if not room_bottom:
		wall_type = randi() % 4
		tilemap.set_cell(offset_x + 3, offset_y + ROOM_SIZE - 1, wall_type, randi() % 2 == 0, randi() % 2 == 0)
		tilemap.set_cell(offset_x + 4, offset_y + ROOM_SIZE - 1, wall_type, randi() % 2 == 0, randi() % 2 == 0)
