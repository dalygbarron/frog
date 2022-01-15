class_name Level
extends Mode

export(String, FILE) var bgm = null
export(String, FILE) var bgs = null
var player: Player
var hud_instance: CanvasLayer
onready var player_part = preload("res://scenes/parts/first_person.tscn")
onready var hud = preload("res://scenes/parts/hud.tscn")

func _ready() -> void:
    if not player:
        var start = $entrances/start
        assert(start)
        player = player_part.instance()
        add_child(player)
        player.global_transform.origin = start.global_transform.origin
    player.connect("interact", self, "interact")
    hud_instance = hud.instance() as CanvasLayer
    hud_instance.player = player
    add_child(hud_instance)
    if bgm: Audio.playBgm(bgm)
    else: Audio.stopBgm()
    if bgs: Audio.playBgs(bgs)
    else: Audio.stopBgs()

func _input(event):
    if event.is_action_released("ui_program_menu"):
        var result = yield(
            Modes.push(Gui.inventory(State.get_items(Item.Tag.MAIN))),
            "finish"
        )

func capture_mouse() -> bool:
    return true
