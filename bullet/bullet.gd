extends Area2D
class_name Bullet
@export var speed := 400

const ownSprite := preload("res://bullet/bullet.png")
const enemySprite := preload("res://bullet/bullet-enemy.png")

var isOwn : bool

func _ready() -> void:
	pass

func start(pos: Vector2, _isOwn: bool) -> void: 
	isOwn = _isOwn
	position = pos	
	if (isOwn):
		collision_layer = 16
		collision_mask = 2
		$bulletSprite.texture = ownSprite
		$PointLight2D.color = Color('#FF63E7')
	else:
		collision_layer = 8
		collision_mask = 1
		$bulletSprite.texture = enemySprite
		$bulletSprite.flip_v = true
		$PointLight2D.color = Color('#70FFFF')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isOwn:
		position.y -= delta * speed
	else:
		position.y += delta * speed


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	queue_free()
