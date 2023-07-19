extends Control

signal start

var score = 0

func _game_start():
	start.emit()
	$"CanvasLayer/Start Game".hide()
	$"CanvasLayer/Quit Game".hide()
	change_lives(3)
	$CanvasLayer/Score.set_text("Score: " + str(score))

func change_lives(lives):
	if(lives == 3):
		$CanvasLayer/Lives.text = "III"
	elif(lives == 2):
		$CanvasLayer/Lives.text = "II"
	elif(lives == 1):
		$CanvasLayer/Lives.text = "I"

func increase_score():
	score += 1
	$CanvasLayer/Score.set_text("Score: " + str(score))
	
func _quit_game():
	get_tree().quit()