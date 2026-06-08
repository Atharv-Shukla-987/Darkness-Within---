class_name player
extends CharacterBody2D


var speed : float = 200.0
var jumppower : float = -500
var gravity :float = 800
var dashspeed :float = 400
var dashtime :float = 0.5
var spcdashspped : float =400
var spcdashsppedtime: float = 0.5
var maxhp :int = 150
var dashcooldowntime : float = 1.5
var spcdashcooldowntime : float = 2

var atkcombo = 0
var hp : int = maxhp
var isdeath:bool = false 
var isdashing : bool = false
var isspedashing : bool = false
var dashtimmer = 0.0
var dashdirec :float = 1.0
var attakbuffer: bool = false
var dashcooldown: float = 0.0
var spcdashcooldown : float = 0.0 
var facing_direction : float = 1.0
var hitboxoffset : Vector2

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var hitbox: Area2D = $hitbox

@onready var spcccdash: AudioStreamPlayer = $spcdash
@onready var running: AudioStreamPlayer = $running
@onready var jump: AudioStreamPlayer = $jump
@onready var dash: AudioStreamPlayer = $dash
@onready var atk: AudioStreamPlayer = $atk










enum states {IDLE,RUN,JUMP,INMIDAIR,FALL,ATK1,ATK2,
JUMPATKUP,JUMPATKDOWN,DASH,DASHATK,SPCDASH,TAKEDAMAGE,DEATH}
var state: states = states.IDLE

func _setstates(nstate:states) -> void:
	if state == nstate:
		return
	state = nstate
	match nstate:
		states.IDLE:     animated_sprite_2d.play("idle")
		states.RUN:      animated_sprite_2d.play("run")
		states.JUMP:     animated_sprite_2d.play("jump")
		states.INMIDAIR : animated_sprite_2d.play("inair ")
		states.FALL :     animated_sprite_2d.play("fall")
		states.ATK1 :      animated_sprite_2d.play("atk1")
		states.ATK2:      animated_sprite_2d.play("atk2")
		states.JUMPATKUP :   animated_sprite_2d.play("jumpup attack")
		states.DASH:       animated_sprite_2d.play("dash")
		states.JUMPATKDOWN : animated_sprite_2d.play("jumpdown attack")
		states.DASHATK : animated_sprite_2d.play("dash attack") 
		states.SPCDASH :   animated_sprite_2d.play("special dash")

		
		states.TAKEDAMAGE  : animated_sprite_2d.play("damage")
		states.DEATH     : animated_sprite_2d.play("death")










func _ready() -> void:
	hp = maxhp
	animated_sprite_2d.animation_finished.connect(_onanimationfinished)
	_setstates(states.IDLE)
	hitboxoffset = hitbox.position

func _physics_process(delta: float) -> void:
	if isdeath:
		move_and_slide()
		return
	_gravity_(delta)
	
	if isdashing:
		_dashmovementhandled(delta)
	else:
		_handle_movement()
		_handlejump()
		_handleattack()
	if dashcooldown > 0.0 :
		dashcooldown -= delta
	if spcdashcooldown > 0.0:
		spcdashcooldown -= delta
	_airstateupdate()
	move_and_slide()
	_flipsprite()
		

# grtavity  for jump 'o'
func _gravity_(delta:float) -> void:
	if not is_on_floor():
		velocity.y += gravity* delta
	else :
		velocity.y = 0.0
		
func _handle_movement() -> void:
	if state  in [states.ATK1,states.ATK2, states.DASHATK, states.TAKEDAMAGE]:
		velocity.x = move_toward(velocity.x,0,speed)
		return
	var dir = Input.get_axis("ui_left" ,  "ui_right")	
	velocity.x = dir * speed
	if is_on_floor():
		if dir!= 0.0 :
			if state not in [states.ATK1,states.ATK2]:
				_setstates(states.RUN)
				
		else:
			_setstates(states.IDLE)
			
			
	
func _handlejump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumppower
		_setstates(states.JUMP)
		jump.play()
		
		
func _handleattack() -> void:
	
	if Input.is_action_just_pressed("dash"):
		_dash(false)
		return
	if Input.is_action_just_pressed("spedash"):
		_dash(true)
		return
	if Input.is_action_just_pressed("attack"):
		if not is_on_floor():
			if Input.is_action_pressed("ui_up"):
				_setstates(states.JUMPATKUP)
				atk.play()
			elif Input.is_action_pressed("ui_down"):
				_setstates(states.JUMPATKDOWN)
				atk.play()
			else:
				_setstates(states.ATK1)
				atk.play()
		else:
			if state in [states.IDLE,states.RUN]:
				atkcombo = 1
				_setstates(states.ATK1)
				atk.play()
			elif state == states.ATK1:
					attakbuffer = true

			
			
func _dash(special:bool) -> void :
	#no double dash lol 
	if isdeath or isdashing:
		return
	if special and spcdashcooldown > 0.0:
		return
	if not special and dashcooldown > 0.0:
		return
	isdashing = true
	isspedashing = special
	dashtimmer = spcdashsppedtime if special else dashtime
	dashdirec = -1.0 if animated_sprite_2d.flip_h else 1.0
	velocity.y = 0.0
	if special:
		spcdashcooldown  = spcdashcooldowntime
	else:
		dashcooldown = dashcooldowntime
	_setstates(states.SPCDASH if special else states.DASH)	
	if special :
		spcccdash.play()
	else: dash.play()
	
	
	
func _dashmovementhandled (delta:float)-> void :
	dashtimmer -= delta
	var speeeed :=spcdashspped if isspedashing else dashspeed
	velocity.x = dashdirec* speeeed
	velocity.y =0
	if not isspedashing and Input.is_action_just_pressed("attack"):
		isdashing = false
		_setstates(states.DASHATK)
		atk.play()	
	if dashtimmer <= 0.0 :
		isdashing = false
		_returntoidleorrun()
	
	
	
	
func takedamage(amt : int) -> void:
	if isdeath :   # not dying twice bro
		return
	hp = hp-amt
	if hp <= 0:
		_death()
	else:
		_setstates(states.TAKEDAMAGE)
	
	
	
func _death() -> void:
	isdeath = true
	isdashing = false
	velocity = Vector2.ZERO
	_setstates(states.DEATH)
	
	
	
	
func _airstateupdate() -> void :
	if isdashing or isdeath :
		return    # yes u can dash in air 
		
	if state in [states.ATK1,states.ATK2,states.JUMPATKUP,
	states.JUMPATKDOWN,states.DASHATK,states.TAKEDAMAGE]:
		return
	
	if not is_on_floor():
		if velocity.y > 80 and state != states.FALL:
			_setstates(states.FALL)
		elif abs(velocity.y)<= 80.0 and state not in [ states.JUMP,states.INMIDAIR]:
			_setstates(states.INMIDAIR)
	else :
		if state in[states.INMIDAIR,states.FALL,states.JUMP]:
			_setstates(states.IDLE)
		
		
		
		
		

		
		
		
		
		
		
		
		 
	
	
	
	
func _onanimationfinished() -> void:
	match state :
		states.ATK1:
			if attakbuffer:
				attakbuffer = false
				atkcombo = 0
				_setstates(states.ATK2)
				atk.play()
			else:
				atkcombo = 0
				_returntoidleorrun()
		states.ATK2:
			_returntoidleorrun()
		states.JUMPATKUP,states.JUMPATKDOWN:
			if is_on_floor():
				_setstates(states.IDLE)
			else :
				_setstates(states.FALL)
		states.DASHATK:
			
			_returntoidleorrun()
		states.JUMP:
			if not is_on_floor():
				_setstates(states.INMIDAIR)
			else:
				_setstates(states.IDLE)
		states.TAKEDAMAGE:
			_returntoidleorrun()
		states.DEATH:
			pass
	
	
	
	
func _update_hitbox_offset() -> void:
	
	hitbox.position.x = hitboxoffset.x * facing_direction
	hitbox.position.y = hitboxoffset.y
	
func _returntoidleorrun() -> void:
	var dir := Input.get_axis("ui_left","ui_right")
	if is_on_floor()and dir !=0.0:
		_setstates(states.RUN)
		
	else:
		_setstates(states.IDLE)
	
	
	

	
	
	
func _flipsprite() -> void:
	var dir := Input.get_axis("ui_left","ui_right")
	if dir != 0.0:
		animated_sprite_2d.flip_h = dir < 0.0
