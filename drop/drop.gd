extends Area2D
class_name Drop
@export var speed := 200

const heartTexture := preload("res://hud/heart.png")

enum DROP_TYPE {HEART}

var type : DROP_TYPE = DROP_TYPE.HEART;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += delta * speed

func start(_position: Vector2) -> void:
	type = DROP_TYPE.values().pick_random()
	match type:
		DROP_TYPE.HEART:
			$dropTexture.texture = heartTexture
	position = _position

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	queue_free()
