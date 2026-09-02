extends Node

const SFX_PATH := "res://audio/sfx/"

var all_sfx: Dictionary = {}
var players: Array[AudioStreamPlayer] = []


func _ready() -> void:
	load_sfx()


func load_sfx() -> void:
	var dir := DirAccess.open(SFX_PATH)

	if dir == null:
		print("SFX folder not found: ", SFX_PATH)
		return

	for file_name in dir.get_files():
		var extension := file_name.get_extension().to_lower()

		if extension not in ["ogg", "wav", "mp3"]:
			continue

		var path := SFX_PATH + file_name
		var sfx := load(path) as AudioStream

		if sfx == null:
			continue

		var sfx_name := file_name.get_basename()
		all_sfx[sfx_name] = sfx

	print("Loaded SFX: ", all_sfx.size())


func play_sfx(sfx_name: String) -> void:
	if not all_sfx.has(sfx_name):
		print("SFX not found: ", sfx_name)
		return

	var player := _get_available_player()

	player.stream = all_sfx[sfx_name]
	player.play()


func _get_available_player() -> AudioStreamPlayer:
	for player in players:
		if not player.playing:
			return player

	var new_player := AudioStreamPlayer.new()
	new_player.bus = "SFX"

	add_child(new_player)
	players.append(new_player)

	return new_player


func set_volume(value: float) -> void:
	for player in players:
		player.volume_db = linear_to_db(value)
