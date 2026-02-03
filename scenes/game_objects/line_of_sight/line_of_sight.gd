class_name LineOfSightMesh
extends MeshInstance3D

@export var line_color: Color = Color.RED
@export var line_thickness: float = 0.05

var _material: StandardMaterial3D
var _raycast: RayCast3D

func _ready() -> void:
	mesh = ImmediateMesh.new()
	
	_material = StandardMaterial3D.new()
	_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_material.albedo_color = line_color
	_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material_override = _material


func set_raycast(raycast: RayCast3D) -> void:
	_raycast = raycast


func update_line() -> void:
	if not _raycast:
		return
	
	# Get raycast information
	var from = _raycast.global_position
	var end_point: Vector3
	
	if _raycast.is_colliding():
		end_point = _raycast.get_collision_point()
	else:
		end_point = _raycast.to_global(_raycast.target_position)
	
	var local_from = to_local(from)
	var local_to = to_local(end_point)
	
	_draw_triangular_prism(local_from, local_to)


func _draw_triangular_prism(from: Vector3, to: Vector3) -> void:
	var immediate_mesh = mesh as ImmediateMesh
	immediate_mesh.clear_surfaces()
	
	var distance = from.distance_to(to)
	if distance < 0.001:
		return
	
	# Calculate orientation
	var direction = (to - from).normalized()
	var transform = _get_prism_transform(from, direction)
	

	# Triangle is in the XZ plane
	var radius = line_thickness
	var triangle_vertices = [
		Vector3(0, 0, radius),
		Vector3(-radius * 0.866, 0, -radius * 0.5),  
		Vector3(radius * 0.866, 0, -radius * 0.5)
	]
	
	var vertices = []
	for i in range(3):
		var start_vert = triangle_vertices[i]
		start_vert.y = 0
		vertices.append(transform * start_vert)
		
	for i in range(3):
		var end_vert = triangle_vertices[i]
		end_vert.y = distance
		vertices.append(transform * end_vert)
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES, _material)
	
	# Front triangle face (at start)
	immediate_mesh.surface_add_vertex(vertices[0])
	immediate_mesh.surface_add_vertex(vertices[1])
	immediate_mesh.surface_add_vertex(vertices[2])
	
	# Back triangle face (at end)
	immediate_mesh.surface_add_vertex(vertices[3])
	immediate_mesh.surface_add_vertex(vertices[5])
	immediate_mesh.surface_add_vertex(vertices[4])
	
	# Side face 1 (connecting vertices 0-3)
	immediate_mesh.surface_add_vertex(vertices[0])
	immediate_mesh.surface_add_vertex(vertices[3])
	immediate_mesh.surface_add_vertex(vertices[1])
	
	immediate_mesh.surface_add_vertex(vertices[1])
	immediate_mesh.surface_add_vertex(vertices[3])
	immediate_mesh.surface_add_vertex(vertices[4])
	
	# Side face 2 (connecting vertices 1-4)
	immediate_mesh.surface_add_vertex(vertices[1])
	immediate_mesh.surface_add_vertex(vertices[4])
	immediate_mesh.surface_add_vertex(vertices[2])
	
	immediate_mesh.surface_add_vertex(vertices[2])
	immediate_mesh.surface_add_vertex(vertices[4])
	immediate_mesh.surface_add_vertex(vertices[5])
	
	# Side face 3 (connecting vertices 2-5)
	immediate_mesh.surface_add_vertex(vertices[2])
	immediate_mesh.surface_add_vertex(vertices[5])
	immediate_mesh.surface_add_vertex(vertices[0])
	
	immediate_mesh.surface_add_vertex(vertices[0])
	immediate_mesh.surface_add_vertex(vertices[5])
	immediate_mesh.surface_add_vertex(vertices[3])
	
	immediate_mesh.surface_end()


func _get_prism_transform(position: Vector3, direction: Vector3) -> Transform3D:
	var up = Vector3.UP
	if abs(direction.dot(up)) > 0.99:
		up = Vector3.RIGHT
	
	var right = direction.cross(up).normalized()
	var forward = right.cross(direction).normalized()
	
	var basis = Basis(right, direction, forward)
	return Transform3D(basis, position)
