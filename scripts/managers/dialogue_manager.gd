extends Node

func show_short_message(message:String) -> void :
	print(message)
	Dialogic.VAR.short_message = message
	Dialogic.start("short_message")
