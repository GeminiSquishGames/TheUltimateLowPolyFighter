class_name Fighter
extends RigidBody2D

@export var torque_a : float
@export var torque_b : float

@export var floaty_text : PackedScene = preload("res://floaty_text.tscn")
@export var spark : PackedScene

@export var health_bar : ProgressBar

@export var color : Color

signal end_fight

var health := 100

var floaty

var contact_point

func _ready() -> void:
    $Polygon2D.color = color

func _process(delta: float) -> void:
    if health <= 0:
        end_fight.emit(self)


func _physics_process(delta: float) -> void:
    var rand_torque = randfn(torque_a, torque_b)
    if global_position.x > 960:
        rand_torque *= -1
    apply_torque_impulse(rand_torque)


func _on_body_entered(body: Node) -> void:
    if body is RigidBody2D:
        floaty = floaty_text.instantiate()
        var sparky := spark.instantiate()

        var dmg : int
        var dmg_ln
        var dmg_an
        dmg_ln = sqrt( body.linear_velocity.length_squared()) * 0.01
        dmg_an = abs(body.angular_velocity)
        dmg = (dmg_an + dmg_ln) / 2

        health -= dmg
        health_bar.value = health


        floaty.set_text( "-%d" % dmg )
        floaty.set_color(color)
        floaty.position += position
        get_tree().root.add_child(floaty)
        print("%s : %4.2f" % [body.name, dmg ] )

        sparky.get_child(0).emitting = true
        sparky.position = contact_point
        get_tree().root.add_child(sparky)

        $AudioStreamPlayer2D.play()


func _integrate_forces(state):
    contact_point = state.get_contact_collider_position(0)
