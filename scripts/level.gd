class_name Level
extends Spatial

const MENU_RETURN = "Return"
const MENU_SAVE_AND_CONTINUE = "Save and Continue"
const MENU_SAVE_AND_QUIT = "Save and Quit"
const MENU_OPTIONS = [
    MENU_RETURN,
    MENU_SAVE_AND_CONTINUE,
    MENU_SAVE_AND_QUIT
]
const VIEW_POINT := Vector3(-3, 3, 2)
const TURN_TIME := 0.3

export(String, FILE) var bgm = null
export(String, FILE) var bgs = null
var camera: PlayerCamera
var player: Player
onready var player_part = preload("res://scenes/parts/player.tscn")
onready var hud = preload("res://scenes/parts/hud.tscn")

func _ready() -> void:
    if not player:
        var start = $entrances/start
        assert(start)
        player = player_part.instance()
        add_child(player)
        player.global_transform.origin = start.global_transform.origin
    player.connect("interact", self, "interact")
    camera = PlayerCamera.new()
    camera.target = player
    var hud_instance = hud.instance()
    hud_instance.player = player
    add_child(camera)
    add_child(hud_instance)
    if bgm: Audio.playBgm(bgm)
    else: Audio.stopBgm()
    if bgs: Audio.playBgs(bgs)
    else: Audio.stopBgs()

func _process(delta: float) -> void:
    if Input.is_action_just_pressed("ui_game_menu"):
        var use: Item = yield(
            Gui.inventory(State.get_holdables(Holdable.Tag.MAIN)),
            "completed"
        ) as Item
        if use: player.use_item(use)
    elif Input.is_action_just_pressed("ui_program_menu"):
        var choice = yield(Gui.notice("Paused", MENU_OPTIONS), "completed")
        player.status = Player.Status.STATIC
        match MENU_OPTIONS[choice]:
            MENU_SAVE_AND_CONTINUE:
                yield(Gui.say("saved"), "completed")
            MENU_SAVE_AND_QUIT:
                yield(Gui.say("saved now should wuit"), "completed")
        player.status = Player.Status.ACTIVE

func interact(cunt: Cunt, holdable: Holdable) -> void:
    if cunt: _talk(cunt, holdable)
    elif holdable: player.use_holdable(holdable)

func _talk(cunt: Cunt, holdable: Holdable) -> void:
    var a: Vector3 = player.global_transform.origin + \
        player.global_transform.basis.xform(VIEW_POINT)
    var b: Vector3 = player.global_transform.origin + \
        player.global_transform.basis.xform(VIEW_POINT * Vector3(1, 1, -1))
    var choice := a
    var a_distance = camera.global_transform.origin.distance_to(a)
    var b_distance = camera.global_transform.origin.distance_to(b)
    if a_distance > b_distance:
        choice = b
    player.status = Cunt.Status.STATIC
    cunt.status = Cunt.Status.STATIC
    cunt.voice()
    cunt.look(player.global_transform.origin, TURN_TIME)
    player.look(cunt.global_transform.origin, TURN_TIME)
    # TODO: add a nice animation where the player whips out an itemme
    if cunt.has_method(Cunt.ACTIVATE_METHOD):
        yield(cunt.call(Cunt.ACTIVATE_METHOD, player, holdable), "completed")
    elif has_method(cunt.name):
        yield(call(cunt.name, cunt, holdable), "completed")
    else:
        yield(Gui.say("Missing function for %s" % cunt.name), "completed")
    player.status = Cunt.Status.ACTIVE
    cunt.status = Cunt.Status.ACTIVE
