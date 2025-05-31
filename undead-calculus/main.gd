#Background Credit: https://www.pinterest.com/pin/342695852913944388/
#Font Credit: https://www.1001fonts.com/arcadeclassic-font.html
extends Node2D


func _on_button_pressed() -> void:			#Coded attribution: youtube - freeCodeCamp.org -  https://www.youtube.com/watch?v=S8lMTwSRoRg
	get_tree().change_scene_to_file("res://main_level.tscn")



func _on_button_2_pressed() -> void:
	get_tree().quit()
