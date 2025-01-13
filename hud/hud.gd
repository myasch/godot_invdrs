extends CanvasLayer
class_name HUD
signal start;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func show_start_menu() -> void:
	switch_to_menu()
	$menu/menuLabel.text = "invdrs"
	$menu/restartButton.text = "start"

func show_restart_menu() -> void:
	switch_to_menu()
	$menu/menuLabel.text = "you died"
	$menu/restartButton.text = "restart"
	
func switch_to_game_hud() -> void:
	$menu.hide()
	$lives.show()
	$scoreLabel.show()
	
func switch_to_menu() -> void:
	$menu.show()
	$lives.hide()
	$scoreLabel.hide()
	
func update_score(score: int) -> void:
	$scoreLabel.text = str(score)

func update_lives(amount: int) -> void:
	$lives/livesCountLabel.text = 'x' + str(amount);
	
func update_fire_rate(rate: int) -> void:
	$lives/fireRateLabel.text = str(float(rate) / 1000)
	
func update_level(level: int) -> void:
	$levelContainer/levelText.text = str(level)

func _on_restart_button_pressed() -> void:
	start.emit()

func _on_exit_button_pressed() -> void:
	get_tree().quit();
