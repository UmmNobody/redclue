extends Node

const MUSIC_PATH := "res://audio/music/"

@onready var music_player: AudioStreamPlayer = $MusicPlayer

var all_music: Dictionary = {}
var current_music: String = ""


func _ready() -> void:
	load_music()


func load_music() -> void:
	var dir := DirAccess.open(MUSIC_PATH)

	if dir == null:
		print("Music folder not found: ", MUSIC_PATH)
		return

	for file_name in dir.get_files():
		var extension := file_name.get_extension().to_lower()

		if extension not in ["ogg", "wav", "mp3"]:
			continue

		var path := MUSIC_PATH + file_name
		var music := load(path) as AudioStream

		if music == null:
			continue

		var music_name := file_name.get_basename()
		all_music[music_name] = music

	print("Loaded Music: ", all_music.size())


func play_music(music_name: String) -> void:
	if not all_music.has(music_name):
		print("Music not found: ", music_name)
		return

	# ถ้าเพลงเดิมกำลังเล่นอยู่ ไม่ต้องเริ่มใหม่
	if current_music == music_name and music_player.playing:
		return

	music_player.stop()
	music_player.stream = all_music[music_name]
	music_player.play()

	current_music = music_name


func stop_music() -> void:
	music_player.stop()
	current_music = ""


func set_volume(value: float) -> void:
	music_player.volume_db = linear_to_db(value)
