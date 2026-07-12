extends CharacterBody2D
class_name Player


const ACCEL = 60.0
const DECEL = 70.0
const SPEED = 250.0
const JUMP_VELOCITY = -500.0

enum JumpStates {
	IDLE,
	START,
	JUMP,
	FALL,
	LAND
}

var jump_state: JumpStates = JumpStates.IDLE
var jump_ready: bool = false
var buffer_jump: bool = false

enum SwordStates {
	IDLE,
	GROUND,
	AIR
}

var sword_state: SwordStates = SwordStates.IDLE
@export var sword_can_stop: bool = false
var buffer_sword: bool = false

var facing_left: bool = false
var on_wall: bool = false

@onready var sprite: AnimatedSprite2D = $Kris
@onready var anim: AnimationPlayer = $Animator
@onready var coyote_timer: Timer = $CoyoteTimer

@onready var r_sword_col: CollisionShape2D = $RightSlash/Collision
@onready var l_sword_col: CollisionShape2D = $LeftSlash/Collision

@export var camera: Camera2D

func _physics_process(delta: float) -> void:
	if is_on_floor():
		if jump_state != JumpStates.START:
			coyote_timer.start()
		if sword_state == SwordStates.AIR:
			if sprite.animation == "slash_air" and sprite.frame < 2:
				jump_state = JumpStates.IDLE
				sword_state = SwordStates.GROUND
				if facing_left:
					anim.play("slash_ground_l")
				else:
					anim.play("slash_ground_r")
				anim.seek(0.534)
				sprite.play("slash_ground")
				sprite.frame = 8
			else:
				sword_state = SwordStates.IDLE
		elif jump_state != JumpStates.LAND and jump_state != JumpStates.START:
			jump_state = JumpStates.IDLE
		if jump_state == JumpStates.START and sprite.animation != "jump_start":
			jump_state = JumpStates.IDLE
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if (Input.is_action_just_pressed("m_jump") or buffer_jump == true) and !coyote_timer.is_stopped() and jump_state != JumpStates.START and sword_state == SwordStates.IDLE:
		buffer_jump = false
		jump_state = JumpStates.START
		if facing_left:
			anim.play("jump_start_l")
		else:
			anim.play("jump_start_r")
		coyote_timer.stop()
	elif Input.is_action_just_pressed("m_jump") and !coyote_timer.is_stopped() and jump_state != JumpStates.START and sword_state == SwordStates.GROUND:
		buffer_jump = true
	if !Input.is_action_pressed("m_jump") and jump_state == JumpStates.JUMP:
		velocity.y /= 3
		jump_state = JumpStates.FALL
	
	if jump_ready:
		velocity.y = JUMP_VELOCITY
		jump_state = JumpStates.JUMP
		jump_ready = false
	
	if velocity.y > 0.0 and jump_state != JumpStates.START:
		jump_state = JumpStates.FALL
		if sword_state == SwordStates.IDLE:
			if facing_left:
				anim.play("jump_down_l")
			else:
				anim.play("jump_down_r")
	elif velocity.y < 0.0 and jump_state == JumpStates.JUMP and sword_state != SwordStates.AIR:
		if facing_left:
			anim.play("jump_up_l")
		else:
			anim.play("jump_up_r")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("m_left", "m_right")
	if direction and sword_state != SwordStates.GROUND:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL)
		if direction < 0:
			facing_left = true
		elif direction > 0:
			facing_left = false
		if is_on_floor() and !on_wall and jump_state != JumpStates.START and jump_state != JumpStates.JUMP:
			if facing_left:
				anim.play("run_l")
			else:
				anim.play("run_r")
		if direction < 0 and velocity.x > 0 and is_on_floor() and jump_state != JumpStates.START and sword_state == SwordStates.IDLE:
			anim.play("turn_l")
		elif direction > 0 and velocity.x < 0 and is_on_floor() and jump_state != JumpStates.START and sword_state == SwordStates.IDLE:
			anim.play("turn_r")
	else:
		velocity.x = move_toward(velocity.x, 0, DECEL)
		if is_on_floor():
			if sprite.animation == "run":
				if facing_left:
					anim.play("runstop_l")
				else:
					anim.play("runstop_r")
			if velocity.x == 0 and jump_state == JumpStates.IDLE and sword_state == SwordStates.IDLE and sprite.animation != "land" and sprite.animation != "runstop":
				if facing_left:
					anim.play("idle_l")
				else:
					anim.play("idle_r")
	
	# Handle sword
	if (Input.is_action_just_pressed("m_sword") or (buffer_sword == true and !is_on_floor())) and jump_state != JumpStates.START:
		buffer_sword = false
		if is_on_floor():
			jump_state = JumpStates.IDLE
			sword_state = SwordStates.GROUND
			if facing_left:
				anim.play("slash_ground_l")
			else:
				anim.play("slash_ground_r")
		else:
			sword_state = SwordStates.AIR
			if facing_left:
				anim.play("slash_air_l")
			else:
				anim.play("slash_air_r")
	elif Input.is_action_just_pressed("m_sword") and jump_state == JumpStates.START:
		buffer_sword = true
	if (!Input.is_action_pressed("m_sword") or buffer_jump == true) and sword_can_stop and sword_state != SwordStates.IDLE:
		sword_state = SwordStates.IDLE
	
	move_and_slide()
	
	if is_on_floor() and velocity.x == 0 and jump_state == JumpStates.FALL:
		jump_state = JumpStates.LAND
		if facing_left:
			anim.play("land_l")
		else:
			anim.play("land_r")
	
	# Fix wall animations
	if velocity.x == 0.0 and is_on_wall() and is_on_floor() and sprite.animation != "idle" and jump_state == JumpStates.IDLE and sword_state == SwordStates.IDLE:
		on_wall = true
		if facing_left:
			anim.play("idle_l")
		else:
			anim.play("idle_r")
	elif velocity.x != 0.0:
		on_wall = false
	
	# Stop permanent sword
	if sword_state == SwordStates.IDLE:
		r_sword_col.disabled = true
		l_sword_col.disabled = true


func _on_kris_animation_finished() -> void:
	if sprite.animation == "land" and jump_state != JumpStates.START:
		if facing_left:
			anim.play("idle_l")
		else:
			anim.play("idle_r")
		jump_state = JumpStates.IDLE
	if sprite.animation == "runstop" and jump_state != JumpStates.START and sword_state == SwordStates.IDLE:
		if facing_left:
			anim.play("idle_l")
		else:
			anim.play("idle_r")
	if sprite.animation == "jump_start":
		jump_ready = true
	if sprite.animation == "slash_ground":
		sword_state = SwordStates.IDLE
	if sprite.animation == "slash_air":
		sword_state = SwordStates.IDLE


func _on_right_slash_body_entered(body: Node2D) -> void:
	body.hit()
	


func _on_left_slash_body_entered(body: Node2D) -> void:
	body.hit()


func hit():
	GM.player_hp -= 20
	pulse()
	if GM.player_hp <= 0:
		get_tree().reload_current_scene()

func pulse():
	modulate.a = 0.5
	await get_tree().create_timer(0.1).timeout
	modulate.a = 1.0
