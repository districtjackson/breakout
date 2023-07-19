extends Control

signal start

var score = 0

func _game_start():
	start.emit()
	$"CanvasLayer/Start Game".hide()
	$"CanvasLayer/Quit Game".hide()
	$CanvasLayer/Score.show()
	$CanvasLayer/Lives.show()
	
	change_lives(3)
	$CanvasLayer/Score.set_text("Score: " + str(score))

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
	$CanvasLayer/Score.set_text("Score: " + str(score))
	
func game_over():
	$CanvasLayer/Score.hide()
	$CanvasLayer/Lives.hide()
	
	$"CanvasLayer/Game Over".set_text("Game Over!\nScore: " + str(score))
	$"CanvasLayer/Game Over".show()
	
	await get_tree().create_timer(4).timeout
	$"CanvasLayer/Game Over".hide()
	
	$"CanvasLayer/Start Game".show()
	$"CanvasLayer/Quit Game".show()
	
func _quit_game():
	get_tree().quit()
