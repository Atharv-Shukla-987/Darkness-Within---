extends CharacterBody2D

var maxhealth : int = 100
var health :int = 100
var speed : int = 60
var atkdamage :int = 20
var knockback : float = 200.0
var ptrdis = 100
var ptrorigin = Vector2.ZERO
var ptrdir = 1  



# states 

enum State {patrol , chase , atk , hurt , dead}
var state =  State.patrol
var player = null
var atkcdn : bool = false
var isknkbck  : bool= false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") 

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection: Area2D = $Area2D
@onready var hitbox: Area2D = $hitbox
@onready var healthbar: ProgressBar = $healthbar




func _ready() -> void:
	ptrorigin = global_position
	detection.body_entered.connect(_on_player_detected)
	detection.body_exited.connect(_on_player_lost)
	hitbox.body_entered.connect(_on_hit_player)
	hitbox.monitoring = false 
	healthbar.max_value = maxhealth
	healthbar.value = health
	
	
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

		
	match state :
		State.patrol   : do_ptr()
		State.chase   : chase()
		State.atk     : pass
		State.hurt     : pass
		State.dead    : pass
	move_and_slide()
	
	
	
	
	
	
	
	
	
	
	
	
	
func do_ptr():
	animated_sprite_2d.play("idle")
	velocity.x = speed * ptrdir
	animated_sprite_2d.flip_h = ptrdir < 0 
	
	var dist = global_position.x - ptrorigin.x
	if dist > ptrdis :
		ptrdir = -1
	elif dist < - ptrdis :
		ptrdir = 1
		
	if abs(velocity.x) >0:
		animated_sprite_2d.play("run")
				
func chase():
	if player == null:
		state = State.patrol
		return
	var dir = sign(player.global_position.x - global_position.x)
	velocity.x = speed * 1.5 *dir
	animated_sprite_2d.flip_h = dir < 0
	animated_sprite_2d.play("run")
	if global_position.distance_to(player.global_position) < 45 :
		statk()
		
		
func statk():
	if atkcdn :
		return
	state = State.atk
	atkcdn = true
	animated_sprite_2d.play("atk")
	hitbox.monitoring = true
	
	await  animated_sprite_2d.animation_finished
	hitbox.monitoring = false
	state = State.chase
	
	await  get_tree().create_timer(1.2).timeout
	atkcdn = false
	
	



func takedmg (amt:int, hitdir :float):
	if state == State.dead:
		return
	health -= amt
	healthbar.value = health
	updatehealthbar()
	
	var kbdir = sign(hitdir) if hitdir != 0 else -1
	velocity.x = kbdir * knockback
	velocity.y = - 100
	
	state =State.hurt
	animated_sprite_2d.play("hit")
	await animated_sprite_2d.animation_finished
	
	if health <= 0:
		die()
	else :
		state = State.chase  if player else State.patrol
	
	
	
func die():
	state = State.dead
	velocity = Vector2.ZERO
	hitbox.monitoring = false
	animated_sprite_2d.play("diie")
	healthbar.hide()
	await animated_sprite_2d.animation_finished
	queue_free()
	
	
	
	
	
func updatehealthbar():
	var pct = float(health)/ maxhealth
	if pct > 0.5 :
		healthbar.modulate = Color.GREEN
	elif pct > 0.25 :
		healthbar.modulate = Color.YELLOW
	else:
		healthbar.modulate = Color.ORANGE_RED
		


# signals


func _on_player_detected(body):
	if body.is_in_group("player"):
		player = body 
		state = State.chase
		
func _on_player_lost(body):
	if body.is_in_group("player"):
		player = null
		state = State.patrol
		ptrorigin = global_position
		
func _on_hit_player(body):
	if body.is_in_group("player"):
		body.takedmg(atkdamage)
	
	
	
	
