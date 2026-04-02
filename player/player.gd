extends CharacterBody2D
@export var run_speed:int=100
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback:AnimationNodeStateMachinePlayback=animation_tree.get("parameters/StateMachine/playback")

#状态
var input_vector:Vector2=Vector2.ZERO
var last_input_vector:Vector2=Vector2.ZERO
var current_state="移动状态"

func _physics_process(_delta: float) -> void:
	current_state=playback.get_current_node()
	match current_state:
		"移动状态":
			input_vector=get_input_vector()
			last_input_vector=Vector2(input_vector.x,-input_vector.y)
			if input_vector!=Vector2.ZERO:
				update_blend_vector(last_input_vector)
				velocity=input_vector*run_speed
				move_and_slide()
#更新混合位置
func update_blend_vector(direction_vector:Vector2):
	animation_tree.set("parameters/StateMachine/移动状态/移动/blend_position",direction_vector)
	animation_tree.set("parameters/StateMachine/移动状态/站立状态/blend_position",direction_vector)

func get_input_vector()->Vector2:
	var vector=Vector2.ZERO
	vector.x=Input.get_action_strength("run_right")-Input.get_action_strength("run_left")
	vector.y=Input.get_action_strength("run_down")-Input.get_action_strength("run_up")
	return vector.normalized()
