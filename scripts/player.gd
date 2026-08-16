extends CharacterBody3D

class_name Player


@export var projectile_blueprint: PackedScene

const SPEED = 5.0
const DASH_VELOCITY = 20

@onready var attackCooldown = $AttackCooldown
@onready var stateMachine = $StateMachine
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if Input.is_action_pressed("shoot") && attackCooldown.time_left == 0:
		shoot()
		
	

	move_and_slide()

func shoot() -> void: 
	#prevents crashes if scene is missing
	if not projectile_blueprint: return
	
	var new_projectile = projectile_blueprint.instantiate() as Projectile
	owner.add_child(new_projectile)
	
	#spawn projectile at player pos
	new_projectile.global_position = self.global_position
	
	#get moust pos
	var mouse_pos = get_viewport().get_mouse_position()
	
	# Get player in screen pixels (Vector2)
	var camera = get_viewport().get_camera_3d()
	var player_screen_pos = camera.unproject_position(self.global_position)
	print ("player screen position: " + str(player_screen_pos))
	print(str(self.global_position))
	
	
	# Calculate a 2D direction vector on the screen
	var screen_direction = (mouse_pos - player_screen_pos).normalized()
	print("screen dir x: " + str(screen_direction.x))
	print("screen dir y: " + str(screen_direction.y))
	
	
	# Convert that 2D direction into a 3D target destination
	# We map screen X to world X, and screen Y to world Y (or world Z)
	var target_3d_position = self.global_position + Vector3(screen_direction.x, 0.0, screen_direction.y)
	
	new_projectile.launch(target_3d_position)
	
	attackCooldown.start()
