extends Sprite2D

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

@export var textures: Array[Texture2D]

var note_colors
@onready var particle_gens: Array[CPUParticles2D] = [cpu_particles_2d]

var generator_position := [
	Vector2(-83,57),
	Vector2(-115,63),
	Vector2(-151,85),
	Vector2(-173,96),
	Vector2(-192,107)
]

func spawn_particle(track_idx:int, texture_idx:int):
	
	var particle_gen: CPUParticles2D
	print(particle_gens)
	
	var ready_gens = particle_gens.filter(func(x): return not x.emitting and not x.has_meta("last_operation"))
	if not ready_gens.is_empty():
		particle_gen = ready_gens.front()

	else:
		particle_gen = cpu_particles_2d.duplicate()
		add_child(particle_gen)
		particle_gens.append(particle_gen)
	
		if particle_gens.size() > 2:
			particle_gens[0].set_meta('last_operation',true)
			particle_gens.back().finished.connect(_kill_particle_gen.bind(particle_gen))
			
	print(particle_gen)
	particle_gen.position = generator_position[track_idx]
	particle_gen.color = note_colors[track_idx]
	await get_tree().process_frame
	particle_gen.emitting = true
	


func _kill_particle_gen(gen: CPUParticles2D):
	particle_gens.erase(gen)
	gen.queue_free()
	
