extends Area2D
class_name Invader

signal died;

var main : Main

const texture1 := preload("res://invader/invader1.png")
const texture2 := preload("res://invader/invader2.png")
const texture3 := preload("res://invader/invader3.png")

const drop := preload("res://drop/drop.tscn")
const bulletResource := preload("res://bullet/bullet.tscn")

const texturesArr := [texture1, texture2, texture3]

func start(pos: Vector2) -> void:
	position = pos;
	
func shoot() -> void:
	var bullet := bulletResource.instantiate()
	main.add_child(bullet)
	bullet.start(Vector2(position.x + 16, position.y), false)

func _ready() -> void:
	$invaderSprite.texture = texturesArr.pick_random()
	main = get_parent()

func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if randi_range(0, 99) < 10:
		var instDrop : Drop = drop.instantiate()
		get_parent().add_child(instDrop)
		instDrop.start(position)
	queue_free()
	died.emit()
