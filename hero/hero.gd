extends Area2D
@export var speed := 400

signal died;
signal gotHeart;
signal gotFireRateUp;

const default_sprite := preload("res://hero/hero.png")
const broken_sprite := preload("res://hero/hero_dead.png")
const bullet := preload("res://bullet/bullet.tscn")
const InitialPosition = Vector2(640, 656)

var isDied := true;

var main : Main

var screen_size: Vector2
var lastShotTimestamp : int

func _ready() -> void:
	screen_size = get_viewport_rect().size
	main = get_parent()
	
func _process(delta: float) -> void:
	if isDied:
		return
	var velocity := Vector2.ZERO
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -=1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if Input.is_action_pressed("shoot"):
		var currentTime := Time.get_ticks_msec()
		if (!lastShotTimestamp) or ((currentTime - lastShotTimestamp) > Stats.fireCooldown):
			var bulletPos = position
			bulletPos.y -= 48
			
			var newBullet : Bullet = bullet.instantiate()
			main.add_child(newBullet)
			newBullet.start(bulletPos, true)
			lastShotTimestamp = currentTime

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('bullets'):
		Stats.lives -= 1
		if Stats.lives == 0:
			isDied = true
			hide()
			$CollisionPolygon2D.disabled = true
		else:
			$sprite.texture = broken_sprite
			await get_tree().create_timer(0.25).timeout
			$sprite.texture = default_sprite
		died.emit()
	elif area.is_in_group('drops'):
		var drop : Drop = area
		if (drop.type == drop.DROP_TYPE.HEART):
			gotHeart.emit()
		elif (drop.type == drop.DROP_TYPE.FIRE_SPEED_UP):
			gotFireRateUp.emit()

func start() -> void:
	isDied = false;
	show()
	Stats.fireCooldown = Stats.InitialFire
	$CollisionPolygon2D.disabled = false
	position = InitialPosition
