extends Node
class_name Main

const invaderResource := preload("res://invader/invader.tscn")

const w := 1280
const h := 720

var score := 0;
var lives := 0;

func _ready() -> void:
	$hud.show_start_menu()

func _process(delta: float) -> void:
	pass

func spawnEnemyWave() -> void:
	var test : Path2D = $enemyPath;
	for x in range(50, w - 29, 100):
		for y in range(50, 451, 100):
			var newInvader : Invader = invaderResource.instantiate()
			add_child(newInvader)
			newInvader.start(Vector2(x, y))
	var invaders := get_tree().get_nodes_in_group("invaders")
	for invader in invaders:
		(invader as Invader).died.connect(_on_invader_died.bind())

func _on_shoot_timer_timeout() -> void:
	var invaders := get_tree().get_nodes_in_group("invaders")
	var invader : Invader = invaders.pick_random()
	if (invader):
		invader.shoot()

func _on_invader_died() -> void:
	score += 1
	$hud.update_score(score)

func _on_hero_died() -> void:
	$hud.update_lives(lives)
	if lives == 0:
		var invaders := get_tree().get_nodes_in_group("invaders")
		$shoot_timer.stop()	
		await get_tree().create_timer(1).timeout
		for invader in invaders:
			if (invader && weakref(invader).get_ref()):
				invader.queue_free();
		$hud.show_restart_menu()
	else:
		$shoot_timer.stop()
		await get_tree().create_timer(0.5).timeout
		$shoot_timer.start()

func _on_hud_start() -> void:
	score = 0;
	lives = 3;
	$hud.switch_to_game_hud()
	$shoot_timer.start()
	$hud.update_score(score);
	$hud.update_lives(lives);
	$hero.start()
	spawnEnemyWave()

func _on_hero_got_heart() -> void:
	lives += 1;
	$hud.update_lives(lives)
