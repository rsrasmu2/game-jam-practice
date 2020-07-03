extends Node

export(int) var gravity = 50000
export(NodePath) var ground_checker_path

export(AudioStream) var land_audio_stream

var parent = null
var ground_checker

var _enabled = true

func _ready():
	ground_checker = get_node(ground_checker_path)
	ground_checker.connect("started_colliding", self, "_on_landed")
	
	if land_audio_stream:
		$LandAudio.stream = land_audio_stream

func init(parent):
	self.parent = parent

func _physics_process(delta):
	if not _enabled:
		return
	
	if not ground_checker.is_colliding:
		parent.velocity.y += gravity * delta   #times delta twice due to acceleration

func _on_landed():
	parent.velocity.y = 0
	$LandAudio.play()

func set_enabled(enabled):
	_enabled = enabled
	if not _enabled:
		parent.velocity.y = max(0, parent.velocity.y)
