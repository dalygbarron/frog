class_name Item
extends Node

export(String) var display_name
export(Texture) var icon: Texture
export(String, MULTILINE) var description
export(Holdable.Tag) var tag
export(bool) var active = false
export(String) var verb = "Use now"

func to_holdable() -> ItemHoldable:
    return ItemHoldable.new(self)

class ItemHoldable extends Holdable:
    var _item: Item

    func _init(item: Item):
        _item = item

    func get_display_name() -> String:
        return _item.display_name

    func get_technical_name() -> String:
        return _item.name

    func get_tag():
        return _item.tag

    func get_icon() -> Texture:
        return _item.icon

    func get_description() -> String:
        return _item.description

    func get_active() -> bool:
        return _item.description

    func get_verb() -> String:
        return _item.verb
