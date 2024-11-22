extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var isAttacking : bool = false

@onready var animated_sprite = $AnimatedSprite2D



func _ready():
	Global.playerBody = self


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_action_pressed("lmclick"):
		animated_sprite.play("attack")
		isAttacking = true
		await animated_sprite.animation_finished
		isAttacking = false
	if direction < 0: 
		animated_sprite.play("run")
		animated_sprite.flip_h = true
	if direction > 0: 
		animated_sprite.play("run")
		animated_sprite.flip_h = false
	if direction == 0:
		animated_sprite.play("idle")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("dealing damage")
