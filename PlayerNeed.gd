extends Node3D

@export var health : Need;
@export var hunger : Need;

@export var no_numger_health_decay : float;

func _ready():
	health = get_node("Health")
	hunger = get_node("Hunger")
	
	health.value = health.start_value
	hunger.value = hunger.start_value

func _process(delta):
	hunger.subtract(hunger.decay_rate * 20 * delta)
		
	if hunger.value == 0:
		health.subtract(no_numger_health_decay * delta)

	if health.value == 0:
		health.ui_bar.need_name = "You died"

	health.update_ui_bar()
	hunger.update_ui_bar()
	pass;
