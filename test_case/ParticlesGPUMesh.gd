extends Node3D

const NPOINTS := 20

var actor: MeshInstance3D
var points: Array[Vector3]
var particle_instance : GPUParticles3D
var spawning := false
var show_debug := true
var mesh_data_tool := MeshDataTool.new()
var rng := RandomNumberGenerator.new()
var spawn_points: Array[MeshInstance3D]

func _ready() -> void:
	spawn_points.resize(NPOINTS)

	# Setup particle system
	particle_instance = $GPUParticles3D
	particle_instance.amount = NPOINTS

	# Setup actor and mesh data
	actor = $rat/Rat3
	points.resize(NPOINTS)
	mesh_data_tool.create_from_surface(actor.mesh, 0)

	calc_spawn_points()

func _process(_delta: float) -> void:
	if spawning:
		particle_instance.restart()
		calc_spawn_points()

		# Spawn particles
		var particle_velocity := Vector3.UP * 4
		for point in points:
			var global_pos := actor.to_global(point)
			particle_instance.emit_particle(Transform3D(Basis.IDENTITY, global_pos), particle_velocity, Color.BLACK, Color.BLACK, 1 + 4 + 8)

	#redraw spawn_points
	for point in spawn_points:
		if point:
			point.queue_free()
	for i in range(len(points)):
		var global_pos := actor.to_global(points[i])
		spawn_points[i] = draw_point(global_pos)

func _input(event):
	if event is InputEventMouseButton or event is InputEventKey:
		spawning = event.pressed

func calc_spawn_points() -> void:
	# Calculate spawn points on the mesh
	rng.seed += 1
	var vertex_count := mesh_data_tool.get_vertex_count()
	for i in range(NPOINTS):
		points[i] = mesh_data_tool.get_vertex(rng.randi_range(0, vertex_count - 1))


func draw_point(pos: Vector3) -> MeshInstance3D:
	var mesh := MeshInstance3D.new()
	var sphere := SphereMesh.new()
	var mat := ORMMaterial3D.new()
	
	mesh.mesh = sphere
	mesh.position = pos
	mesh.material_override = mat
	
	sphere.radius = 0.04
	sphere.height = 0.08
	mat.albedo_color = Color.FIREBRICK
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	get_tree().get_root().add_child(mesh)
	return mesh
