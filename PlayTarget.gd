extends Area2D

func _ready():
	pass

func particles():
	print("particles")
	$Particles2D.emitting = true
	$Timer.start()


func _on_Timer_timeout():
	print("particles timer")
	$Particles2D.emitting = false
