extends Node3D

var time: float;
@export var day_length: float = 10;
@export var start_time : float = 0.3
var time_rate: float 

var sun : DirectionalLight3D
var moon: DirectionalLight3D
@export var sun_color: Gradient;
@export var sun_intensity : Curve;

var environment: WorldEnvironment;
@export var sky_top_color: Gradient;
@export var sky_horizon_color: Gradient;

func _ready():
	time_rate = 1.0 / day_length;
	time = start_time
	sun = get_node("Sun");
	moon = get_node("Moon");
	environment = get_node("WorldEnvironment")
	


func _process(delta):
	time += time_rate * delta;
	
	if time >= 1.0: 
		time = 0.0;
	
	sun.rotation_degrees.x = time * 360 + 90;
	sun.light_color = sun_color.sample(time)
	sun.light_energy = sun_intensity.sample(time)
	
	moon.rotation_degrees.x = time * 360 + 270;
	moon.light_color = Color.DARK_BLUE
	moon.light_energy = 1 - sun_intensity.sample(time)
	
	# enable and disable the moon
	sun.visible = sun.light_energy > 0
	moon.visible = moon.light_energy > 0
	
	#setting sky color;
	environment.environment.sky.sky_material.set("sky_top_color", sky_top_color.sample(time))
	environment.environment.sky.sky_material.set("sky_horizon_color", sky_horizon_color.sample(time))
	environment.environment.sky.sky_material.set("ground_bottom_color", sky_top_color.sample(time))
	environment.environment.sky.sky_material.set("ground_horizon_color", sky_horizon_color.sample(time))
