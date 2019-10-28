extends Area2D

func _ready():
	pass

func particles():
	$Particles2D.emitting = true
	$Timer.start()


func _on_Timer_timeout():
	$Particles2D.emitting = false
