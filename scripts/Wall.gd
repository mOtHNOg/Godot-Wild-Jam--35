extends Node2D

onready var toothbrush_parent = $ToothbrushParent
#onready var toothbrush_aura_parent = $ToothbrushAuraParent

const toothbrush_object = preload("res://scenes/Toothbrush.tscn")

var disabled: bool = false

func _ready() -> void:
	Global.wall = self

func _process(_delta) -> void:
	visible = ! disabled

func _spawn_toothbrush() -> void:
	var toothbrush_instance = toothbrush_object.instance()
	toothbrush_parent.add_child(toothbrush_instance)
