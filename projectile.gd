extends Node3D
class_name Projectile

var max_distance = 50
var speed = 10

var velocity: Vector3 = Vector3.ZERO


func launch(target_position: Vector3) -> void:
	var direction = (target_position - global_position).normalized()
	velocity = direction * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.y = 0
	global_position += velocity * delta

	
