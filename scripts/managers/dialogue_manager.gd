extends Node

func show_short_message(message:String) -> void :
	Dialogic.VAR.short_message = message
	Dialogic.start("short_message")
