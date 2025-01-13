extends Node
class_name Main

const invaderResource := preload("res://invader/invader.tscn")

const w := 1280
const h := 720

func _ready() -> void:
	$hud.show_start_menu()

func _process(delta: float) -> void:
	pass

func spawnEnemyWave() -> void:
	var enemiesRange := 200 - (Stats.level - 1) * 20
	var test : Path2D = $enemyPath;
	for x in range(50, w - 29, enemiesRange):
		for y in range(50, 451, enemiesRange):
			var newInvader : Invader = invaderResource.instantiate()
			add_child(newInvader)
			newInvader.start(Vector2(x, y))
	var invaders := get_tree().get_nodes_in_group("invaders")
	for invader in invaders:
		(invader as Invader).died.connect(_on_invader_died.bind())

func _on_shoot_timer_timeout() -> void:
	var invaders := get_tree().get_nodes_in_group("invaders")
	for i in range(Stats.level):
		var invader : Invader = invaders.pick_random()
		if (invader):
			invader.shoot()

func _on_invader_died() -> void:
	Stats.score += 1
	$hud.update_score(Stats.score)
	var invaders := get_tree().get_nodes_in_group("invaders")
	if len(invaders.filter(func(it): return isNodeNotFreed(it) and is_instance_valid(it) and !it.is_queued_for_deletion())) == 0:
		Stats.level += 1
		$hud.update_level(Stats.level);
		spawnEnemyWave()

func _on_hero_died() -> void:
	$hud.update_lives(Stats.lives)
	if Stats.lives == 0:
		var invaders := get_tree().get_nodes_in_group("invaders")
		$shoot_timer.stop()	
		await get_tree().create_timer(1).timeout
		for invader in invaders:
			if (isNodeNotFreed(invader)):
				invader.queue_free();
		$hud.show_restart_menu()
	else:
		$shoot_timer.stop()
		await get_tree().create_timer(0.5).timeout
		$shoot_timer.start()

func _on_hud_start() -> void:
	Stats.score = 0;
	Stats.level = 1;
	Stats.lives = Stats.InitialHearts;
	
	$hud.switch_to_game_hud();
	$hud.update_score(Stats.score);
	$hud.update_lives(Stats.lives);
	$hud.update_level(Stats.level);
	
	$hero.start();
	spawnEnemyWave();
	$shoot_timer.start();

func _on_hero_got_heart() -> void:
	Stats.lives += 1;
	$hud.update_lives(Stats.lives)

func isNodeNotFreed(it) -> bool:
	return it and weakref(it).get_ref()

func _on_hero_got_fire_rate_up() -> void:
	Stats.fireCooldown -= 100
	$hud.update_fire_rate(Stats.fireCooldown)
