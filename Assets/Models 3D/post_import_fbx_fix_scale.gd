@tool
extends EditorScenePostImport

# À assigner dans "Advanced Import Settings" du FBX, champ Script.
# Retire le scale de TOUS les nodes de la hiérarchie (pas seulement
# les MeshInstance3D), en gravant le scale global cumulé dans les
# vertices des mesh, et en réajustant les transforms locaux pour
# que rien ne bouge visuellement.

func _post_import(scene: Node) -> Object:
	print("=== fix_scale v2: DEBUT ===")
	var original_globals := {}
	_collect_global_transforms(scene, original_globals)
	_strip_scale_recursive(scene, Transform3D.IDENTITY, original_globals)
	print("=== fix_scale v2: FIN ===")
	return scene

# --- Passe 1 : on capture le transform global (calcule "a la main",
# sans dependre de node.global_transform qui peut ne pas etre fiable
# hors de l'arbre de scene actif) AVANT toute modification ---
func _collect_global_transforms(node: Node, out: Dictionary) -> void:
	if node is Node3D:
		out[node] = _manual_global_transform(node)
	for child in node.get_children():
		_collect_global_transforms(child, out)

func _manual_global_transform(node: Node3D) -> Transform3D:
	var t: Transform3D = node.transform
	var p := node.get_parent()
	while p != null and p is Node3D:
		t = (p as Node3D).transform * t
		p = p.get_parent()
	return t

# --- Passe 2 : du parent vers les enfants, on retire le scale de
# chaque node, et on grave le scale global d'origine dans les mesh ---
func _strip_scale_recursive(node: Node, parent_new_global: Transform3D, original_globals: Dictionary) -> void:
	var this_new_global := parent_new_global

	if node is Node3D:
		var orig_global: Transform3D = original_globals[node]
		var scale: Vector3 = orig_global.basis.get_scale()
		var rot_only := orig_global.basis.orthonormalized()
		this_new_global = Transform3D(rot_only, orig_global.origin)

		var new_local: Transform3D = parent_new_global.affine_inverse() * this_new_global
		node.transform = new_local

		if node is MeshInstance3D and node.mesh != null and not scale.is_equal_approx(Vector3.ONE):
			print("Bake scale global sur ", node.name, " : ", scale)
			_bake_scale_into_mesh(node, scale)

	for child in node.get_children():
		_strip_scale_recursive(child, this_new_global, original_globals)

func _bake_scale_into_mesh(mesh_instance: MeshInstance3D, scale: Vector3) -> void:
	var scale_basis := Basis().scaled(scale)
	var normal_basis := scale_basis.inverse().transposed()

	var old_mesh: Mesh = mesh_instance.mesh
	var new_mesh := ArrayMesh.new()

	for surf_idx in old_mesh.get_surface_count():
		var arrays := old_mesh.surface_get_arrays(surf_idx)

		if arrays[Mesh.ARRAY_VERTEX] != null:
			var verts: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
			for i in verts.size():
				verts[i] = scale_basis * verts[i]
			arrays[Mesh.ARRAY_VERTEX] = verts

		if arrays[Mesh.ARRAY_NORMAL] != null:
			var normals: PackedVector3Array = arrays[Mesh.ARRAY_NORMAL]
			for i in normals.size():
				normals[i] = (normal_basis * normals[i]).normalized()
			arrays[Mesh.ARRAY_NORMAL] = normals

		new_mesh.add_surface_from_arrays(old_mesh.surface_get_primitive_type(surf_idx), arrays)
		new_mesh.surface_set_material(surf_idx, old_mesh.surface_get_material(surf_idx))

	mesh_instance.mesh = new_mesh
