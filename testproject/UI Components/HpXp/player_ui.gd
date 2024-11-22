extends VBoxContainer

@onready var xp: int = 0
@onready var health: int = 100
@onready var xpToLevel: int = 150
@onready var maxHealth: int = 100
@onready var level = 1
@onready var previousLevel = 0
var damage = 10
@onready var _gain_xp = Global.experienceGained


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$healthBar.value = health
	$experienceBar.value = xp
	$experienceBar.max_value = xpToLevel


func take_damage():
	health = health - damage
	$healthBar.value = health
	if health <= 0:
		print("oh dear, you are dead")
	
	
func gainXp():
	xp += Global.experienceGained
	$experienceBar.value = Global.experienceGained
	if xp >= $experienceBar.max_value: 
		xp = 0
		xpToLevel *= 1.2
		$experienceBar.max_value = xpToLevel
		$experienceBar.value = xp
		level += 1
		update_health_on_level()
		previousLevel += 1
		
	
func update_health_on_level():
	if previousLevel == level - 2:
		maxHealth *= 1.1
		$healthBar.max_value = maxHealth
		health = maxHealth
		$healthBar.value = health
		print("maxhealth updated to ", maxHealth)
	else:
		print("error")
		
func _on_button_pressed() -> void:
	take_damage()
	print(health)
	print(maxHealth)


func _on_button_2_pressed() -> void:
	gainXp()
	print(level)
	print(xp, " out of ", xpToLevel, " until next level")
	print(previousLevel)
