extends CharacterBody2D

var speed : float = 200.0
var jumppower : float = -500
var gravity :float = 800
var dashspeed :float = 500
var dashtime :float = 0.5
var spcdashspped : float = 900
var spcdashsppedtime: float = 900
var maxhp :int = 150

var hp : int = maxhp
var isdeath:bool = false 
var isdashing : bool = false
var isspcdashing : bool = false
var dashtimmer = 0.0
var dashdirec :float = 1.0
var attakbuffer: bool = false


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D







enum states {IDLE,RUN,JUMP,INMIDAIR,FALL,ATK1,ATK2,
JUMPATKUP,JUMPATKDOWN,DASH,DASHATK,SPCDASH,TAKEDAMAGE,DEATH}
var state: states = states.IDLE

func _ready() -> void:
	hp = maxhp
	
	_set_state(states.IDLE)
	
