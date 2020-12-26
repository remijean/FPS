extends Spatial

var walk_blend := 0.0

onready var arms_body = $Arms/Skeleton/Body
onready var arms_nails = $Arms/Skeleton/Nails
onready var animation_tree = $"../../AnimationTree"
onready var player = $"../../../Player"

func _ready():
	arms_body.set_cast_shadows_setting(false)
	arms_nails.set_cast_shadows_setting(false)

func _on_Player_state_changed(state, delta):
	match state:
		player.IDLE:
			set_walk_blend(0, delta)
		player.WALK:
			set_walk_blend(1, delta)

func set_walk_blend(to, delta):
	walk_blend = lerp(walk_blend, to, 10 * delta)
	animation_tree.set("parameters/WalkBlend/blend_amount", walk_blend)
