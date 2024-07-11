extends XRController3D

@export var grab_distance: float = 3.0
@export var grab_strength: float = 10.0

@onready var ray_cast: RayCast3D = $RayCast
@onready var camera: XRCamera3D = $Camera

var grabbed_object: RigidBody3D = null

const JOY_BUTTON_GRAB = 7  # Change this to the appropriate button index

# Input event handling
func _input(event):
	if event is InputEventJoypadButton and event.pressed:
		if event.button_index == JOY_BUTTON_GRAB:  # Assuming this is the grab button
			if grabbed_object:
				release_object()
			else:
				grab_object()

# Ray cast to grab an object
func grab_object():
	ray_cast.target_position = camera.global_transform.basis.z * grab_distance
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		grabbed_object = ray_cast.get_collider() as RigidBody3D
		if grabbed_object:
			grabbed_object.mode = PhysicsServer3D.BODY_MODE_KINEMATIC
			grabbed_object.global_transform.origin = ray_cast.get_collision_point()

# Release the grabbed object
func release_object():
	if grabbed_object:
		grabbed_object.mode = PhysicsServer3D.BODY_MODE_RIGID
		grabbed_object = null

# Update the position of the grabbed object
func _process(delta):
	if grabbed_object:
		grabbed_object.global_transform.origin = camera.global_transform.origin + camera.global_transform.basis.z * grab_distance


func _on_button_pressed(name):
	print(name)
	pass # Replace with function body.
