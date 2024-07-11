extends Node3D

# here use this base material
@export var highlight_mat : BaseMaterial3D
@export var holder_node : Node3D
@export var pickable_group : String
@export var animation_player : AnimationPlayer
@export var xr_action : String = 'trigger_click'
@export var raycast : RayCast3D = null

enum InteractioMode {INTERACT_CLUTCHING,INTERACT_TRIGGER}

@export var interaction_mode : InteractioMode = InteractioMode.INTERACT_TRIGGER 

# Tasks for now ...
# 1) make the highlight work - override_material
# 1.1) get the actual object that is hit ... 
# 1.2) make material override working!

var highlight_meshes = []
var colliders = []

	
# Task for exersise
# - start and stop with pressing 'S' (or any other button)
# - cancel ...
# - rewire into the actual interaction (between trigger and release)




func _physics_process(delta):
	
	# remove override for highlights
	for e in highlight_meshes:
		e.material_override = null
		
	# empty selected mesh 
	highlight_meshes = []
	
	colliders = []
	
	if raycast.is_colliding():
		var c = raycast.get_collider()
		
		# if pickable or not (NPC)
		if pickable_group in c.get_groups():
			colliders.append(c)

		# get children
		for element in c.get_children():
			# check if this is a Mesh and if highlight_mat is set
			if element is MeshInstance3D and highlight_mat:
				# override and store
				element.material_override = highlight_mat
				highlight_meshes.append(element)

		match interaction_mode:
			# using trigger for clutch and release
			InteractioMode.INTERACT_CLUTCHING:
				if Input.is_action_just_pressed("ui_accept"):
					animation_player.play('RESET')
					animation_player.stop()
					if holder_node.get_child_count():
						for child in holder_node.get_children():
							child.reparent(get_node('/root'))
					else:
						c.reparent(holder_node)
						animation_player.play('Idle')

			InteractioMode.INTERACT_TRIGGER:
				# need to hold key/trigger to interact
				if Input.is_action_pressed('ui_accept'):
					_on_controller_right_button_pressed(xr_action)

				elif Input.is_action_just_released('ui_accept'):
					_on_controller_right_button_released(xr_action)

						
			_:
				print('Unknown Mode!')



func _on_controller_right_button_pressed(name):
	
	if holder_node.get_child_count() == 0 and not colliders.is_empty():
		for c in colliders:
			c.reparent(holder_node)
			#animation_player.play('Idle')


func _on_controller_right_button_released(name):
						
	#animation_player.play('RESET')
	#sanimation_player.stop()
	
	for child in holder_node.get_children():
		child.reparent(get_node('/root'))
