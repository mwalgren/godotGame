extends CharacterBody2D

class_name skeletonEnemy

const speed = 40 
var health = 80
var maxhealth = 80
var healthMin = 0

var is_skeleton_aggro: bool = false
var taking_damage: bool = false
var dead: bool = false

var damage = 20
var is_dealing_damage: bool = false

const gravity = 900
var knockBack = 200

var is_roaming: bool = true
var dir: Vector2
var player = CharacterBody2D
var player_in_area = false

@onready var animated_sprite = $AnimatedSprite2D


func _process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
		
		
	player = Global.playerBody
		
	move(delta)
	handle_animations()
	move_and_slide()


func move(delta):
		if !dead:
			if !is_skeleton_aggro:
				velocity += dir * speed * delta
			elif  is_skeleton_aggro and !taking_damage:
				var dir_to_player = position.direction_to(player.position) * speed
				velocity.x = dir_to_player.x
			is_roaming = true
		elif dead:
			velocity.x = 0 


func handle_animations():
	var animated_sprite = $AnimatedSprite2D
	if !dead and !taking_damage and !is_dealing_damage:
		animated_sprite.play("walk")
	if velocity.x > 0: 
		$AnimatedSprite2D.flip_h = false
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x == 0:
		animated_sprite.play("idle")
	elif !dead and taking_damage and !is_dealing_damage:
		animated_sprite.play("takehit")
		await get_tree().create_timer(0.8).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		animated_sprite.play("death")
		await get_tree().create_timer(0.8).timeout
		handle_death()



func handle_death():
	self.queue_free()


func _on_timer_timeout():
	$Timer.wait_time = choose([1.5,2.0,2.5])
	if !is_skeleton_aggro:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0


func choose(array):
	array.shuffle()
	return array.front()


func _on_agrro_range_body_entered(body: Node2D) -> void:
	is_skeleton_aggro = true
	print("entered area")


func _on_agrro_range_body_exited(body: Node2D) -> void:
	is_skeleton_aggro = false
	print("exited area")


func _on_skeleton_hit_box_area_entered(area):
	health -= Global.damage_amount
	print(health)
	animated_sprite.play("takehit")
	taking_damage = true
	await get_tree().create_timer(0.4).timeout
	if health == healthMin:
		animated_sprite.play("death")
		await get_tree().create_timer(0.8).timeout
		Global.experienceGained += 20
		print("You gained ", Global.experienceGained, " experience")
		queue_free()
