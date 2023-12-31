extends Control

signal start
signal high_score_beaten(score)

var score = 0
var high_score = 0

func set_high_score(hscore):
	high_score = hscore

func _game_start():
	start.emit()
	
	# Setup HUD counts
	score = 0
	change_lives(3)
	$CanvasLayer/Score.set_text(str(score))
	$CanvasLayer/HighScore.set_text("High Score:\n" + str(high_score))
	
	# Show/hide necessary HUD elements
	$"CanvasLayer/Start Game".hide()
	$"CanvasLayer/Quit Game".hide()
	$CanvasLayer/Title.hide()
	$CanvasLayer/Score.show()
	$CanvasLayer/Lives.show()
	$CanvasLayer/HighScore.show()
	$Bar.show()

func change_lives(lives):
	if(lives == 3):
		$CanvasLayer/Lives.text = "III"
	elif(lives == 2):
		$CanvasLayer/Lives.text = "II"
	elif(lives == 1):
		$CanvasLayer/Lives.text = "I"

# Increment score each time a brick is destroyed
func increase_score():
	score += 1
	$CanvasLayer/Score.set_text(str(score))
	
func game_over():
	$CanvasLayer/Score.hide()
	$CanvasLayer/Lives.hide()
	$CanvasLayer/HighScore.hide()
	$Bar.hide()
	
	$"CanvasLayer/Game Over".set_text("Game Over!\nScore: " + str(score))
	$"CanvasLayer/Game Over".show()
	
	if(score > high_score):
		high_score_beaten.emit(score)
	
	await get_tree().create_timer(4).timeout
	$"CanvasLayer/Game Over".hide()
	
	$"CanvasLayer/Start Game".show()
	$"CanvasLayer/Quit Game".show()
	$CanvasLayer/Title.show()
	
func _quit_game():
	get_tree().quit()
