extends Node3D
class_name Projectile

@export var max_distance = 50
@export var speed = 10
@export var dmg = 2

var velocity: Vector3 = Vector3.ZERO


func launch(target_position: Vector3) -> void:
	var direction = (target_position - global_position).normalized()
	velocity = direction * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.y = 0
	global_position += velocity * delta




func _on_area_entered(area: Area3D) -> void:
	print("oof ouch im shot!")
	print(area)
	if area.has_method("take_damage"):
		#var target = area.get_parent()
		#target.take_damage(dmg)
		area.take_damage(dmg)
