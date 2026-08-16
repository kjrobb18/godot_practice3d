extends CharacterBody3D

enum EnemyState {IDLE, PATROL, HOSTILE, RETURN}

@export var initial_state: EnemyState
@export var max_hp: int = 2
@export var speed: float
@export var target_body: Node3D
@export var return_threshold = 0.2

@onready var pat_timer = $"PatrolTimer"
@onready var body_mesh = $BodyMesh

var current_state: EnemyState
var direction: Vector3
var return_position: Vector3
var turn_speed: float =  7.0
var current_hp: int = max_hp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("This is ready")
	current_state = initial_state
	pat_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	# Change state upon timer reaching 0		
	if pat_timer.time_left == 0 && current_state == EnemyState.IDLE:
		current_state = EnemyState.PATROL
		direction = Vector3(randf_range(-100, 100), 0 , randf_range(-100, 100)).normalized()
		pat_timer.start(randf_range(2, 6))
	elif pat_timer.time_left == 0 && current_state == EnemyState.PATROL:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		current_state = EnemyState.IDLE
		pat_timer.start(randf_range(2, 6))
	
	
	
	if current_state == EnemyState.PATROL:
		face_target(delta)
		velocity = direction * speed
	elif current_state == EnemyState.HOSTILE:
		#direction = Vector3(target_body.global_position.x, 0, target_body.global_position.z).normalized()
		direction = (target_body.global_position - global_position).normalized()
		face_target(delta)
		velocity = direction * speed
	#Return to position enemy was at before aggro. Change to IDLE once there and reset timer.
	elif (current_state == EnemyState.RETURN):
		var distance_to_target = global_position.distance_to(return_position)
		if distance_to_target <= return_threshold:
			velocity = Vector3.ZERO
			current_state = EnemyState.IDLE
			pat_timer.start(randf_range(2, 6))
		else: 
			direction = (return_position - global_position).normalized()
			face_target(delta)
			velocity = direction * speed
			print(velocity)
		
	
	
	
	move_and_slide()


## This turns the enemy to face the direction they are moving
func face_target(delta: float) -> void: 
	var target_angle = atan2(velocity.x, velocity.z)
	body_mesh.rotation.y = lerp_angle(body_mesh.rotation.y, target_angle, turn_speed * delta)
	

func take_damage(damage: int) -> void:
	current_hp = current_hp - damage
	if current_hp <= 0: 
		die()

func die() -> void: 
	queue_free()

func _on_aggro_zone_body_entered(body: Node3D) -> void:
	return_position = self.global_position
	current_state = EnemyState.HOSTILE
	target_body = body


func _on_aggro_zone_body_exited(body: Node3D) -> void:
	current_state = EnemyState.RETURN
