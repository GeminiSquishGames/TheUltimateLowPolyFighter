extends Node2D

var text_settings := LabelSettings.new()
var color : Color


func _ready() -> void:
    $FloatyTextLabel.label_settings = text_settings
    text_settings.font_size = 20
    text_settings.outline_size = 5



func set_color( color : Color):
    text_settings.font_color = color


func set_text( txt : String):
    $FloatyTextLabel.text = txt
